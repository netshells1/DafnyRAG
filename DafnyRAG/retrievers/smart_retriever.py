"""
智能检索器 - 多策略检索
"""
from typing import List, Dict, Tuple
from langchain_core.documents import Document
import re


class SmartRetriever:
    """智能检索器 - 使用多查询策略和上下文增强"""
    
    def __init__(self, case_db, error_db, grammar_db):
        self.case_db = case_db
        self.error_db = error_db
        self.grammar_db = grammar_db
    
    def extract_code_features(self, code: str) -> Dict[str, any]:
        """提取代码的关键特征"""
        features = {
            'has_loop': False,
            'has_recursion': False,
            'has_array': False,
            'has_requires': False,
            'has_ensures': False,
            'has_invariant': False,
            'has_decreases': False,
            'method_names': [],
            'function_names': []
        }
        
        code_lower = code.lower()
        
        # 检测循环
        if 'while' in code_lower or 'for' in code_lower:
            features['has_loop'] = True
        
        # 检测数组/序列
        if 'array' in code_lower or 'seq' in code_lower or '[' in code:
            features['has_array'] = True
        
        # 检测规约
        features['has_requires'] = 'requires' in code_lower
        features['has_ensures'] = 'ensures' in code_lower
        features['has_invariant'] = 'invariant' in code_lower
        features['has_decreases'] = 'decreases' in code_lower
        
        # 提取方法名
        method_pattern = r'method\s+(\w+)'
        features['method_names'] = re.findall(method_pattern, code)
        
        # 提取函数名
        function_pattern = r'function\s+(\w+)'
        features['function_names'] = re.findall(function_pattern, code)
        
        # 检测递归(方法名在方法体中出现)
        for method_name in features['method_names']:
            if method_name in code[code.find(method_name) + len(method_name):]:
                features['has_recursion'] = True
                break
        
        return features
    
    def build_multi_queries(
        self,
        buggy_code: str,
        verifier_errors: List[str],
        error_classification: Dict
    ) -> List[Tuple[str, str, float]]:
        """
        构建多个检索查询
        
        Returns:
            List of (query, query_type, weight)
        """
        queries = []
        
        # 1. 主要错误查询(权重最高)
        if verifier_errors:
            primary_error = verifier_errors[0]
            # 提取错误的核心信息
            error_core = self._extract_error_core(primary_error)
            queries.append((error_core, "primary_error", 1.0))
        
        # 2. 错误类型查询
        primary_type = error_classification.get('primary_type')
        if primary_type:
            type_query = f"{primary_type.value} error in Dafny"
            queries.append((type_query, "error_type", 0.8))
        
        # 3. 代码特征查询
        features = self.extract_code_features(buggy_code)
        feature_query = self._build_feature_query(features)
        if feature_query:
            queries.append((feature_query, "code_features", 0.6))
        
        # 4. 代码片段查询(包含错误上下文)
        if verifier_errors:
            context = self._extract_error_context(buggy_code, verifier_errors[0])
            queries.append((context, "code_context", 0.7))
        
        # 5. 所有错误的组合查询
        if len(verifier_errors) > 1:
            combined_errors = "\n".join([
                self._extract_error_core(e) for e in verifier_errors[:3]
            ])
            queries.append((combined_errors, "combined_errors", 0.9))
        
        return queries
    
    def _extract_error_core(self, error_msg: str) -> str:
        """提取错误的核心信息"""
        # 移除文件路径和行号
        error = re.sub(r'^.*?\.dfy\(\d+,\d+\):\s*', '', error_msg)
        # 移除 "Error:" 前缀
        error = re.sub(r'^Error:\s*', '', error)
        return error.strip()
    
    def _extract_error_context(self, code: str, error_msg: str) -> str:
        """提取错误相关的代码上下文"""
        match = re.search(r'\((\d+),(\d+)\)', error_msg)
        if match:
            line_num = int(match.group(1))
            lines = code.split('\n')
            # 返回错误行前后5行
            start = max(0, line_num - 5)
            end = min(len(lines), line_num + 5)
            return '\n'.join(lines[start:end])
        return code[:500]
    
    def _build_feature_query(self, features: Dict) -> str:
        """根据代码特征构建查询"""
        parts = []
        
        if features['has_loop']:
            parts.append("loop")
            if features['has_invariant']:
                parts.append("invariant")
        
        if features['has_recursion']:
            parts.append("recursion")
            if features['has_decreases']:
                parts.append("decreases")
        
        if features['has_array']:
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
        max_total: int = 3
    ) -> Dict[str, List[Document]]:
        """
        使用查询融合进行检索
        
        Returns:
            {
                'case_docs': List[Document],
                'auxiliary_docs': List[Document],
                'auxiliary_source': str
            }
        """
        # 构建多个查询
        queries = self.build_multi_queries(buggy_code, verifier_errors, error_classification)
        
        print(f"\n📝 生成了 {len(queries)} 个检索查询:")
        for query, qtype, weight in queries:
            print(f"  - [{qtype}] (权重: {weight:.1f}) {query[:80]}...")
        
        # 从案例库检索
        case_docs_dict = {}  # 用于去重
        
        for query, qtype, weight in queries:
            docs = self.case_db.similarity_search(query, k=k_per_query)
            for doc in docs:
                doc_id = doc.metadata.get('task_id', doc.page_content[:50])
                if doc_id not in case_docs_dict:
                    case_docs_dict[doc_id] = doc
        
        case_docs = list(case_docs_dict.values())[:max_total]
        print(f"✓ 从案例库检索到 {len(case_docs)} 个不重复案例")
        
        # 根据错误类型选择辅助库
        is_syntax = error_classification.get('is_syntax_error', False)
        is_verification = error_classification.get('is_verification_error', False)
        
        auxiliary_docs = []
        auxiliary_source = ""
        
        if is_syntax:
            # 语法错误 -> 语法库
            print("✓ 检测到语法错误，从语法库检索...")
            auxiliary_source = "grammar"
            
            for query, qtype, weight in queries:
                if qtype in ["primary_error", "code_context"]:
                    docs = self.grammar_db.similarity_search(query, k=2)
                    auxiliary_docs.extend(docs)
        
        elif is_verification:
            # 验证错误 -> 错误理论库
            print("✓ 检测到验证错误，从错误理论库检索...")
            auxiliary_source = "error_theory"
            
            primary_type = error_classification.get('primary_type')
            type_query = f"{primary_type.value} in Dafny verification"
            docs = self.error_db.similarity_search(type_query, k=3)
            auxiliary_docs.extend(docs)
            
            # 额外检索主要错误
            if verifier_errors:
                error_core = self._extract_error_core(verifier_errors[0])
                docs = self.error_db.similarity_search(error_core, k=2)
                auxiliary_docs.extend(docs)
        
        # 去重
        auxiliary_docs_dict = {}
        for doc in auxiliary_docs:
            doc_id = doc.page_content[:100]
            if doc_id not in auxiliary_docs_dict:
                auxiliary_docs_dict[doc_id] = doc
        
        auxiliary_docs = list(auxiliary_docs_dict.values())[:2]
        print(f"✓ 从 {auxiliary_source} 库检索到 {len(auxiliary_docs)} 个不重复文档")
        
        return {
            'case_docs': case_docs,
            'auxiliary_docs': auxiliary_docs,
            'auxiliary_source': auxiliary_source
        }