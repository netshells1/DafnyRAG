"""
Improved Dafny Code Fixer - Fixed JSON Parsing and Error Handling
"""

import os
import re
import json
import shutil
import subprocess
from typing import List, Dict, Optional
from subprocess import TimeoutExpired, CalledProcessError, check_output
from langchain_openai import OpenAIEmbeddings, ChatOpenAI
from langchain_community.vectorstores import Chroma
from langchain_core.documents import Document

import sys

# Add project root to path
current_dir = os.path.dirname(os.path.abspath(__file__))
project_root = os.path.dirname(current_dir)
if project_root not in sys.path:
    sys.path.insert(0, project_root)

from core.error_classifier import ErrorClassifier, ErrorType
from retrievers.smart_retriever import SmartRetriever
from prompts.templatescopy import PromptTemplates


class ImprovedDafnyFixer:
    """Improved Dafny Code Fixer"""

    def __init__(
        self,
        api_key: str,
        base_url: str,
        output_dir: str = "./output_fixed_improved",
        clean_output: bool = True,
        model: str = "gpt-4",
        temperature: float = 0.2,
    ):
        """Initialize the fixer"""
        print("=" * 70)
        print("Initializing Improved Dafny Code Fixer")
        print("=" * 70)

        # Embedding model
        self.embeddings = OpenAIEmbeddings(
            model="text-embedding-3-small",
            openai_api_key=api_key,
            openai_api_base=base_url,
        )

        # Generation model
        self.llm = ChatOpenAI(
            model=model,
            openai_api_key=api_key,
            openai_api_base=base_url,
            temperature=temperature,
        )

        # Output directory
        self.output_dir = output_dir
        if clean_output and os.path.exists(output_dir):
            print(f"Clearing old output directory: {output_dir}")
            shutil.rmtree(output_dir)

        if not os.path.exists(output_dir):
            os.makedirs(output_dir)
            print(f"Created output directory: {output_dir}")

        # Knowledge bases
        self.case_db = None
        self.error_db = None
        self.grammar_db = None

        # Core components
        self.error_classifier = ErrorClassifier()
        self.smart_retriever = None

        print("Fixer initialized successfully.\n")

    def load_all_vectorstores(
        self,
        case_db_dir: str = "./chroma_db",
        case_db_name: str = "dafny_error_cases",
        error_db_dir: str = "./chroma_db_error",
        error_db_name: str = "error_documents",
        grammar_db_dir: str = "./chroma_db_grammar",
        grammar_db_name: str = "grammar_documents",
    ):
        """Load all knowledge bases"""
        print("=" * 70)
        print("Loading Knowledge Bases")
        print("=" * 70)

        try:
            self.case_db = Chroma(
                persist_directory=case_db_dir,
                embedding_function=self.embeddings,
                collection_name=case_db_name,
            )
            print("Case database loaded successfully.")
        except Exception as e:
            print(f"Failed to load case database: {e}")
            raise

        try:
            self.error_db = Chroma(
                persist_directory=error_db_dir,
                embedding_function=self.embeddings,
                collection_name=error_db_name,
            )
            print("Error theory database loaded successfully.")
        except Exception as e:
            print(f"Failed to load error theory database: {e}")
            raise

        try:
            self.grammar_db = Chroma(
                persist_directory=grammar_db_dir,
                embedding_function=self.embeddings,
                collection_name=grammar_db_name,
            )
            print("Grammar database loaded successfully.")
        except Exception as e:
            print(f"Failed to load grammar database: {e}")
            raise

        # Initialize smart retriever
        self.smart_retriever = SmartRetriever(
            self.case_db,
            self.error_db,
            self.grammar_db
        )
        print("Smart retriever initialized successfully.\n")

    def extract_json_from_llm_response(self, content: str) -> Optional[Dict]:
        """
        Improved JSON extraction - supports multiple formats and nested structures.

        Attempts multiple strategies:
        1. Extract ```json ... ``` code blocks
        2. Parse the entire response directly
        3. Find the first { to the last }
        """
        # Strategy 1: Extract JSON code block (improved regex using greedy mode)
        json_match = re.search(r'```json\s*(\{.*\})\s*```', content, re.DOTALL)
        if json_match:
            try:
                return json.loads(json_match.group(1))
            except json.JSONDecodeError as e:
                print(f"Warning: JSON code block parsing failed: {e}")

        # Strategy 2: Try parsing the entire content directly
        try:
            return json.loads(content.strip())
        except json.JSONDecodeError:
            pass

        # Strategy 3: Find first { to last }
        first_brace = content.find('{')
        last_brace = content.rfind('}')

        if first_brace != -1 and last_brace != -1 and last_brace > first_brace:
            try:
                json_str = content[first_brace:last_brace + 1]
                return json.loads(json_str)
            except json.JSONDecodeError as e:
                print(f"Warning: Failed to extract JSON: {e}")

        return None

    def extract_code_from_response(self, content: str) -> Optional[str]:
        """
        Extract Dafny code from an LLM response.

        Supports multiple formats:
        1. ```dafny ... ```
        2. ```java ... ``` (LLMs sometimes mislabel)
        3. ``` ... ``` (no language tag)
        4. Raw code text
        """
        # Try extracting a dafny code block
        dafny_match = re.search(r'```dafny\s*(.*?)\s*```', content, re.DOTALL)
        if dafny_match:
            return dafny_match.group(1).strip()

        # Try extracting a java code block (LLMs sometimes confuse the two)
        java_match = re.search(r'```java\s*(.*?)\s*```', content, re.DOTALL)
        if java_match:
            code = java_match.group(1).strip()
            if 'method' in code or 'function' in code or 'requires' in code:
                return code

        # Try extracting any code block
        code_match = re.search(r'```\s*(.*?)\s*```', content, re.DOTALL)
        if code_match:
            code = code_match.group(1).strip()
            if 'method' in code or 'function' in code:
                return code

        # Fallback: find lines starting with "method", "function", etc.
        lines = content.split('\n')
        code_lines = []
        in_code = False

        for line in lines:
            if re.match(r'^\s*(method|function|class|datatype)\s+\w+', line):
                in_code = True

            if in_code:
                code_lines.append(line)

        if code_lines:
            return '\n'.join(code_lines).strip()

        return None

    def analyze_code(self, code: str, errors: List[str]) -> Dict:
        """Analyze code before attempting a fix"""

        prompt = PromptTemplates.get_analysis_prompt(code, errors)

        try:
            response = self.llm.invoke(prompt)
            content = response.content

            analysis = self.extract_json_from_llm_response(content)

            if analysis:
                return analysis
            else:
                print("Warning: Could not parse analysis result, using defaults.")
                print(f"Raw response (first 500 chars):\n{content[:500]}...")
                return {'difficulty': 'medium'}

        except Exception as e:
            print(f"Warning: Code analysis failed: {e}")
            return {'difficulty': 'medium'}

    def format_cases(self, cases: List[Document]) -> str:
        """Format retrieved cases for prompt injection"""
        if not cases:
            return "No similar cases found."

        formatted = []
        for i, doc in enumerate(cases, 1):
            metadata = doc.metadata
            content = doc.page_content

            try:
                case_data = json.loads(content)
                buggy = case_data.get('buggy_code', 'N/A')
                fixed = case_data.get('fixed_code', 'N/A')
                errors = case_data.get('verifier_errors', [])

                case_text = f"""
### Case {i} (Task: {metadata.get('task_id', 'N/A')})

**Original Error**:
{errors[0] if errors else 'N/A'}

**Buggy Code Snippet**:
```dafny
{buggy}...
```

**Fixed Code Snippet**:
```dafny
{fixed}...
```
"""
            except Exception:
                case_text = f"""
### Case {i}
{content[:500]}...
"""

            formatted.append(case_text)

        return "\n".join(formatted)

    def format_auxiliary_docs(self, docs: List[Document]) -> str:
        """Format auxiliary documents for prompt injection"""
        if not docs:
            return "No relevant documents found."

        formatted = []
        for i, doc in enumerate(docs, 1):
            formatted.append(f"### Knowledge {i}\n{doc.page_content[:800]}...\n")

        return "\n".join(formatted)

    def generate_first_fix(
        self,
        buggy_code: str,
        verifier_errors: List[str]
    ) -> Dict:
        """Generate the first repair attempt with improved parsing logic"""
        print("\n" + "=" * 70)
        print("Step 1: Error Classification")
        print("=" * 70)

        # 1. Error classification
        error_analysis = self.error_classifier.classify_errors(verifier_errors)
        primary_type = error_analysis['primary_type']
        type_counts = error_analysis['type_counts']

        print(f"\nPrimary error type: {primary_type.value}")
        print("Error type breakdown:")
        for etype, count in type_counts.items():
            desc = self.error_classifier.get_error_description(etype)
            print(f"  - {desc}: {count}")

        error_analysis['type_description'] = self.error_classifier.get_error_description(primary_type)

        print("\n" + "=" * 70)
        print("Step 2: Smart Retrieval")
        print("=" * 70)

        # 2. Smart retrieval
        retrieval_result = self.smart_retriever.retrieve_with_fusion(
            buggy_code,
            verifier_errors,
            error_analysis,
            k_per_query=1,
            max_total=3
        )

        case_docs = retrieval_result['case_docs']
        auxiliary_docs = retrieval_result['auxiliary_docs']
        auxiliary_source = retrieval_result['auxiliary_source']

        print("\n" + "=" * 70)
        print("Step 3: Generating Fix")
        print("=" * 70)

        # 3. Format retrieval results
        similar_cases = self.format_cases(case_docs)
        auxiliary_knowledge = self.format_auxiliary_docs(auxiliary_docs)

        # 4. Build prompt
        prompt = PromptTemplates.get_first_fix_prompt(
            buggy_code,
            verifier_errors,
            error_analysis,
            similar_cases,
            auxiliary_knowledge,
            auxiliary_source
        )

        # 5. Call LLM
        print("\nCalling LLM to generate fix...")

        try:
            response = self.llm.invoke(prompt)
            content = response.content

            result = self.extract_json_from_llm_response(content)

            if result and 'fixed_code' in result:
                print("LLM response parsed successfully.")
                print(f"  Understanding  : {result.get('understanding', 'N/A')[:100]}...")
                print(f"  Error cause    : {result.get('error_cause', 'N/A')[:100]}...")
                print(f"  Fix strategy   : {result.get('fix_strategy', 'N/A')[:100]}...")

                return {
                    'fixed_code': result['fixed_code'],
                    'understanding': result.get('understanding', ''),
                    'error_cause': result.get('error_cause', ''),
                    'fix_strategy': result.get('fix_strategy', ''),
                    'key_changes': result.get('key_changes', []),
                    'error_analysis': error_analysis
                }
            else:
                print("Warning: Could not parse JSON. Attempting direct code extraction...")
                print(f"Raw response (first 500 chars):\n{content[:500]}...")

                code = self.extract_code_from_response(content)

                if code:
                    print("Code extracted successfully.")
                    return {
                        'fixed_code': code,
                        'understanding': 'Failed to parse',
                        'error_cause': 'Failed to parse',
                        'fix_strategy': 'Failed to parse',
                        'key_changes': ['Code extracted from response'],
                        'error_analysis': error_analysis
                    }
                else:
                    print("Failed to extract code. Returning original code.")
                    return {
                        'fixed_code': buggy_code,
                        'understanding': 'Parse failed',
                        'error_cause': 'Parse failed',
                        'fix_strategy': 'Parse failed',
                        'key_changes': [],
                        'error_analysis': error_analysis
                    }

        except Exception as e:
            print(f"Failed to generate fix: {e}")
            import traceback
            traceback.print_exc()

            return {
                'fixed_code': buggy_code,
                'understanding': str(e),
                'error_cause': str(e),
                'fix_strategy': str(e),
                'key_changes': [],
                'error_analysis': error_analysis
            }

    def generate_iterative_fix(
        self,
        current_code: str,
        current_errors: List[str],
        iteration: int,
        previous_attempts: List[Dict]
    ) -> Dict:
        """Generate an iterative repair with improved parsing logic"""
        print("\n" + "=" * 70)
        print("Step 1: Error Classification")
        print("=" * 70)

        # Error classification
        error_analysis = self.error_classifier.classify_errors(current_errors)
        primary_type = error_analysis['primary_type']
        type_counts = error_analysis['type_counts']

        print(f"\nPrimary error type: {primary_type.value}")
        print("Error type breakdown:")
        for etype, count in type_counts.items():
            desc = self.error_classifier.get_error_description(etype)
            print(f"  - {desc}: {count}")

        error_analysis['type_description'] = self.error_classifier.get_error_description(primary_type)

        print("\n" + "=" * 70)
        print("Step 2: Building Iterative Prompt")
        print("=" * 70)

        # Build prompt
        prompt = PromptTemplates.get_iterative_fix_prompt(
            current_code,
            current_errors,
            iteration,
            previous_attempts,
            error_analysis
        )

        print("\nCalling LLM to generate fix...")

        try:
            response = self.llm.invoke(prompt)
            content = response.content

            result = self.extract_json_from_llm_response(content)

            if result and 'fixed_code' in result:
                print("LLM response parsed successfully.")
                print(f"  Reflection  : {result.get('reflection', 'N/A')[:100]}...")
                print(f"  New strategy: {result.get('new_strategy', 'N/A')[:100]}...")

                return {
                    'fixed_code': result['fixed_code'],
                    'reflection': result.get('reflection', ''),
                    'new_strategy': result.get('new_strategy', ''),
                    'key_changes': result.get('key_changes', []),
                    'error_analysis': error_analysis
                }
            else:
                print("Warning: Could not parse JSON. Attempting direct code extraction...")
                print(f"Raw response (first 500 chars):\n{content[:500]}...")

                code = self.extract_code_from_response(content)

                if code:
                    print("Code extracted successfully.")
                    return {
                        'fixed_code': code,
                        'reflection': 'Failed to parse',
                        'new_strategy': 'Failed to parse',
                        'key_changes': ['Code extracted from response'],
                        'error_analysis': error_analysis
                    }
                else:
                    print("Failed to extract code. Returning current code.")
                    return {
                        'fixed_code': current_code,
                        'reflection': 'Parse failed',
                        'new_strategy': 'Parse failed',
                        'key_changes': [],
                        'error_analysis': error_analysis
                    }

        except Exception as e:
            print(f"Iterative fix failed: {e}")
            import traceback
            traceback.print_exc()

            return {
                'fixed_code': current_code,
                'reflection': str(e),
                'new_strategy': str(e),
                'key_changes': [],
                'error_analysis': error_analysis
            }

    def save_fixed_code(self, task_id: str, fixed_code: str, iteration: int = 1) -> str:
        """Save the fixed code to a file"""
        filename = f"task_id_{task_id}-iter_{iteration}-fixed.dfy"
        filepath = os.path.join(self.output_dir, filename)

        with open(filepath, "w", encoding="utf-8") as f:
            f.write(fixed_code)

        print(f"Code saved: {filepath}")
        return filepath

    def verify_dafny_code(
        self, dfy_file_path: str, timeout: int = 60
    ) -> tuple[int, int, str]:
        """
        Verify a Dafny source file.

        Returns:
            (verification_count, error_count, output)
        """
        try:
            cmd_output = check_output(
                ["dafny", "/compile:0", dfy_file_path],
                timeout=timeout,
                text=True,
                stderr=subprocess.STDOUT
            )
        except TimeoutExpired:
            print(f"Verification timed out (>{timeout}s)")
            return (0, -1, "Timeout")
        except CalledProcessError as e:
            cmd_output = e.output
        except FileNotFoundError:
            print("Dafny is not installed or not found on PATH.")
            return (0, -2, "Dafny not found")
        except Exception as e:
            print(f"Verification error: {e}")
            return (0, -2, str(e))

        # Parse output
        verification_count = 0
        error_count = 0

        # Check for parse errors (syntax errors) first
        parse_error_match = re.search(r'(\d+)\s+parse\s+errors?', cmd_output, re.IGNORECASE)
        if parse_error_match:
            error_count = int(parse_error_match.group(1))
            verification_count = 0
            return (verification_count, error_count, cmd_output)

        # Check summary line: "X verified, Y errors"
        for line in cmd_output.split('\n'):
            if 'verified' in line.lower():
                match = re.search(r'(\d+)\s+verified', line, re.IGNORECASE)
                if match:
                    verification_count = int(match.group(1))

            error_match = re.search(r'(\d+)\s+errors?', line, re.IGNORECASE)
            if error_match:
                error_count = int(error_match.group(1))
                break

        # Fallback: manually count "Error:" lines if no summary found
        if error_count == 0 and verification_count == 0:
            for line in cmd_output.split('\n'):
                line_stripped = line.strip()
                if (': Error:' in line_stripped or
                        line_stripped.startswith('Error:') or
                        line_stripped.startswith('error:')):
                    error_count += 1

        return (verification_count, error_count, cmd_output)

    def parse_verifier_errors(self, output: str) -> List[str]:
        """Extract error messages from verifier output"""
        errors = []
        for line in output.split('\n'):
            line = line.strip()
            if (': Error:' in line) or (': error:' in line) or \
               line.startswith('Error:') or line.startswith('error:'):
                errors.append(line)

        # Fallback: extract lines containing keywords if no standard errors found
        if not errors and "errors" in output.lower():
            for line in output.split('\n'):
                if any(k in line.lower() for k in ['violation', 'failure', 'could not be proved']):
                    errors.append(line.strip())

        return errors if errors else []

    def save_verification_log(
        self, task_id: str, cmd_output: str, iteration: int = 1
    ) -> str:
        """Save the verification log to a file"""
        filename = f"task_id_{task_id}-iter_{iteration}-verification.log"
        filepath = os.path.join(self.output_dir, filename)

        with open(filepath, "w", encoding="utf-8") as f:
            f.write(cmd_output)

        return filepath

    def iterative_fix_pipeline(
        self,
        buggy_code: str,
        verifier_errors: List[str],
        task_id: str = "unknown",
        max_iterations: int = 5
    ) -> Dict:
        """Run the full iterative repair pipeline"""
        print("\n" + "=" * 70)
        print(f"Starting Iterative Repair Pipeline (max {max_iterations} iterations)")
        print("=" * 70)

        # Ensure knowledge bases are loaded
        if self.case_db is None:
            print("\nKnowledge bases not loaded. Loading now...")
            self.load_all_vectorstores()

        # Analyze code before starting
        analysis = self.analyze_code(buggy_code, verifier_errors)

        fix_history = []
        current_code = buggy_code
        current_errors = verifier_errors

        for iteration in range(1, max_iterations + 1):
            print("\n" + "=" * 70)
            print(f"Iteration {iteration}/{max_iterations}")
            print("=" * 70)

            # Generate fix
            if iteration == 1:
                fix_result = self.generate_first_fix(current_code, current_errors)
            else:
                fix_result = self.generate_iterative_fix(
                    current_code,
                    current_errors,
                    iteration,
                    fix_history
                )

            # Save code
            dfy_path = self.save_fixed_code(task_id, fix_result['fixed_code'], iteration)

            # Verify code
            print(f"\nVerifying fixed code...")
            verification_count, error_count, verification_output = self.verify_dafny_code(dfy_path)

            log_path = self.save_verification_log(task_id, verification_output, iteration)

            # Record this attempt
            iteration_record = {
                'iteration': iteration,
                'code': fix_result['fixed_code'],
                'dfy_file_path': dfy_path,
                'verification_log_path': log_path,
                'verification_count': verification_count,
                'error_count': error_count,
                'verification_output': verification_output,
                'success': error_count == 0,
                'key_changes': fix_result.get('key_changes', [])
            }

            if iteration == 1:
                iteration_record['understanding'] = fix_result.get('understanding', '')
                iteration_record['error_cause'] = fix_result.get('error_cause', '')
                iteration_record['fix_strategy'] = fix_result.get('fix_strategy', '')
            else:
                iteration_record['reflection'] = fix_result.get('reflection', '')
                iteration_record['new_strategy'] = fix_result.get('new_strategy', '')

            fix_history.append(iteration_record)

            # Success requires both passing verifications and zero errors
            is_truly_successful = (error_count == 0 and verification_count > 0)

            if is_truly_successful:
                print(f"\nRepair succeeded on iteration {iteration}!")
                print(f"  Verified: {verification_count} item(s)")
                break
            elif error_count == 0 and verification_count == 0:
                # Ambiguous result: no errors, but also nothing verified
                print(f"\nWarning: Ambiguous verification result on iteration {iteration}.")
                print(f"  verified=0, errors=0 - please inspect manually: {log_path}")
                if iteration >= max_iterations:
                    print("Maximum iterations reached.")
                    break
            elif error_count == -1:
                print("\nVerification timed out.")
                break
            elif error_count == -2:
                print("\nVerification failed.")
            else:
                print(f"\nStill {error_count} error(s) remaining.")
                print(f"  Verified: {verification_count} item(s)")

                if iteration < max_iterations:
                    print(f"\nProceeding to iteration {iteration + 1}...")
                    current_code = fix_result['fixed_code']
                    current_errors = self.parse_verifier_errors(verification_output)
                else:
                    print("Maximum iterations reached.")

        # Return final result
        final_result = fix_history[-1] if fix_history else None

        return {
            'task_id': task_id,
            'original_code': buggy_code,
            'original_errors': verifier_errors,
            'code_analysis': analysis,
            'total_iterations': len(fix_history),
            'max_iterations': max_iterations,
            'fix_history': fix_history,
            'final_success': final_result['success'] if final_result else False,
            'final_code': final_result['code'] if final_result else None,
            'final_error_count': final_result['error_count'] if final_result else -1
        }
