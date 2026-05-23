"""
Smart Retriever - Multi-Strategy Retrieval
"""

import re
from typing import Dict, List, Tuple

from langchain_core.documents import Document


class SmartRetriever:
    """Smart Retriever - uses multi-query strategy and context enhancement."""

    def __init__(self, case_db, error_db, grammar_db):
        self.case_db = case_db
        self.error_db = error_db
        self.grammar_db = grammar_db

    def extract_code_features(self, code: str) -> Dict[str, object]:
        """Extract key features from the code."""
        features = {
            "has_loop": False,
            "has_recursion": False,
            "has_array": False,
            "has_requires": False,
            "has_ensures": False,
            "has_invariant": False,
            "has_decreases": False,
            "method_names": [],
            "function_names": [],
        }

        code_lower = code.lower()

        if "while" in code_lower or "for" in code_lower:
            features["has_loop"] = True

        if "array" in code_lower or "seq" in code_lower or "[" in code:
            features["has_array"] = True

        features["has_requires"] = "requires" in code_lower
        features["has_ensures"] = "ensures" in code_lower
        features["has_invariant"] = "invariant" in code_lower
        features["has_decreases"] = "decreases" in code_lower

        features["method_names"] = re.findall(r"method\s+(\w+)", code)
        features["function_names"] = re.findall(r"function\s+(\w+)", code)

        for method_name in features["method_names"]:
            if method_name in code[code.find(method_name) + len(method_name):]:
                features["has_recursion"] = True
                break

        return features

    def build_multi_queries(
        self,
        buggy_code: str,
        verifier_errors: List[str],
        error_classification: Dict,
    ) -> List[Tuple[str, str, float]]:
        """Build multiple retrieval queries."""
        queries = []

        if verifier_errors:
            primary_error = verifier_errors[0]
            error_core = self._extract_error_core(primary_error)
            queries.append((error_core, "primary_error", 1.0))

        primary_type = error_classification.get("primary_type")
        if primary_type:
            type_query = f"{primary_type.value} error in Dafny"
            queries.append((type_query, "error_type", 0.8))

        features = self.extract_code_features(buggy_code)
        feature_query = self._build_feature_query(features)
        if feature_query:
            queries.append((feature_query, "code_features", 0.6))

        if verifier_errors:
            context = self._extract_error_context(buggy_code, verifier_errors[0])
            queries.append((context, "code_context", 0.7))

        if len(verifier_errors) > 1:
            combined_errors = "\n".join(
                [self._extract_error_core(e) for e in verifier_errors[:3]]
            )
            queries.append((combined_errors, "combined_errors", 0.9))

        return queries

    def _extract_error_core(self, error_msg: str) -> str:
        """Extract core information from an error message."""
        error = re.sub(r"^.*?\.dfy\(\d+,\d+\):\s*", "", error_msg)
        error = re.sub(r"^Error:\s*", "", error)
        return error.strip()

    def _extract_error_context(self, code: str, error_msg: str) -> str:
        """Extract code context related to the error."""
        match = re.search(r"\((\d+),(\d+)\)", error_msg)
        if match:
            line_num = int(match.group(1))
            lines = code.split("\n")
            start = max(0, line_num - 5)
            end = min(len(lines), line_num + 5)
            return "\n".join(lines[start:end])
        return code[:500]

    def _build_feature_query(self, features: Dict[str, object]) -> str:
        """Build a query based on code features."""
        parts = []

        if features["has_loop"]:
            parts.append("loop")
            if features["has_invariant"]:
                parts.append("invariant")

        if features["has_recursion"]:
            parts.append("recursion")
            if features["has_decreases"]:
                parts.append("decreases")

        if features["has_array"]:
            parts.append("array sequence")

        if parts:
            return " ".join(parts) + " in Dafny"
        return ""

    def retrieve_with_fusion(
        self,
        buggy_code: str,
        verifier_errors: List[str],
        error_classification: Dict,
        k_per_query: int = 1,
        max_total: int = 3,
    ) -> Dict[str, List[Document]]:
        """Retrieve using query fusion."""
        queries = self.build_multi_queries(
            buggy_code, verifier_errors, error_classification
        )

        print(f"\nGenerated {len(queries)} retrieval queries:")
        for query, qtype, weight in queries:
            print(f"  - [{qtype}] (weight: {weight:.1f}) {query[:80]}...")

        case_docs_dict = {}

        for query, _qtype, _weight in queries:
            docs = self.case_db.similarity_search(query, k=k_per_query)
            for doc in docs:
                doc_id = doc.metadata.get("task_id", doc.page_content[:50])
                if doc_id not in case_docs_dict:
                    case_docs_dict[doc_id] = doc

        case_docs = list(case_docs_dict.values())[:max_total]
        print(f"Retrieved {len(case_docs)} unique cases from case database")

        is_syntax = error_classification.get("is_syntax_error", False)
        is_verification = error_classification.get("is_verification_error", False)

        auxiliary_docs = []
        auxiliary_source = ""

        if is_syntax:
            print("Syntax error detected, retrieving from grammar database...")
            auxiliary_source = "grammar"

            for query, qtype, _weight in queries:
                if qtype in ["primary_error", "code_context"]:
                    docs = self.grammar_db.similarity_search(query, k=2)
                    auxiliary_docs.extend(docs)

        elif is_verification:
            print("Verification error detected, retrieving from error theory database...")
            auxiliary_source = "error_theory"

            primary_type = error_classification.get("primary_type")
            type_query = f"{primary_type.value} in Dafny verification"
            docs = self.error_db.similarity_search(type_query, k=3)
            auxiliary_docs.extend(docs)

            if verifier_errors:
                error_core = self._extract_error_core(verifier_errors[0])
                docs = self.error_db.similarity_search(error_core, k=2)
                auxiliary_docs.extend(docs)

        auxiliary_docs_dict = {}
        for doc in auxiliary_docs:
            doc_id = doc.page_content[:100]
            if doc_id not in auxiliary_docs_dict:
                auxiliary_docs_dict[doc_id] = doc

        auxiliary_docs = list(auxiliary_docs_dict.values())[:2]
        print(f"Retrieved {len(auxiliary_docs)} unique documents from {auxiliary_source} database")

        return {
            "case_docs": case_docs,
            "auxiliary_docs": auxiliary_docs,
            "auxiliary_source": auxiliary_source,
        }
