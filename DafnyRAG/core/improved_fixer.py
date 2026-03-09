"""
改进的 Dafny 代码修复器 - 修复 JSON 解析和错误处理
"""

import os
import re
import json
import shutil
from typing import List, Dict, Optional
from subprocess import TimeoutExpired, CalledProcessError, check_output
from langchain_openai import OpenAIEmbeddings, ChatOpenAI
from langchain_community.vectorstores import Chroma
from langchain_core.documents import Document

import sys
import os

# 添加项目根目录到路径
current_dir = os.path.dirname(os.path.abspath(__file__))
project_root = os.path.dirname(current_dir)
if project_root not in sys.path:
    sys.path.insert(0, project_root)

from core.error_classifier import ErrorClassifier, ErrorType
from retrievers.smart_retriever import SmartRetriever
from prompts.templates import PromptTemplates


class ImprovedDafnyFixer:
    """改进的 Dafny 代码修复器"""
    
    def __init__(
        self,
        api_key: str,
        base_url: str,
        output_dir: str = "./output_fixed_improved",
        clean_output: bool = True
    ):
        """初始化修复器"""
        print("=" * 70)
        print("初始化改进版 Dafny 代码修复器")
        print("=" * 70)
        
        # 嵌入模型
        self.embeddings = OpenAIEmbeddings(
            model="text-embedding-3-small",
            openai_api_key=api_key,
            openai_api_base=base_url,
        )
        
        # 生成模型
        self.llm = ChatOpenAI(
            # model="gpt-4.1-nano",
            model="gpt-3.5-turbo",
            # model="gpt-4",
            openai_api_key=api_key,
            openai_api_base=base_url,
            temperature=0.2,
        )
    
        # 输出目录
        self.output_dir = output_dir
        if clean_output and os.path.exists(output_dir):
            print(f"🗑️  清空旧的输出目录: {output_dir}")
            shutil.rmtree(output_dir)
        
        if not os.path.exists(output_dir):
            os.makedirs(output_dir)
            print(f"✓ 创建输出目录: {output_dir}")
        
        # 知识库
        self.case_db = None
        self.error_db = None
        self.grammar_db = None
        
        # 核心组件
        self.error_classifier = ErrorClassifier()
        self.smart_retriever = None
        
        print("✓ 修复器初始化完成\n")
    
    def load_all_vectorstores(
        self,
        case_db_dir: str = "./chroma_db",
        case_db_name: str = "dafny_error_cases",
        error_db_dir: str = "./chroma_db_error",
        error_db_name: str = "error_documents",
        grammar_db_dir: str = "./chroma_db_grammar",
        grammar_db_name: str = "grammar_documents",
    ):
        """加载所有知识库"""
        print("=" * 70)
        print("加载知识库")
        print("=" * 70)
        
        try:
            self.case_db = Chroma(
                persist_directory=case_db_dir,
                embedding_function=self.embeddings,
                collection_name=case_db_name,
            )
            print("✓ 案例库加载成功")
        except Exception as e:
            print(f"✗ 案例库加载失败: {e}")
            raise
        
        try:
            self.error_db = Chroma(
                persist_directory=error_db_dir,
                embedding_function=self.embeddings,
                collection_name=error_db_name,
            )
            print("✓ 错误理论库加载成功")
        except Exception as e:
            print(f"✗ 错误理论库加载失败: {e}")
            raise
        
        try:
            self.grammar_db = Chroma(
                persist_directory=grammar_db_dir,
                embedding_function=self.embeddings,
                collection_name=grammar_db_name,
            )
            print("✓ 语法库加载成功")
        except Exception as e:
            print(f"✗ 语法库加载失败: {e}")
            raise
        
        # 初始化智能检索器
        self.smart_retriever = SmartRetriever(
            self.case_db,
            self.error_db,
            self.grammar_db
        )
        print("✓ 智能检索器初始化完成\n")
    
    def extract_json_from_llm_response(self, content: str) -> Optional[Dict]:
        """
        改进的 JSON 提取方法 - 支持多种格式和嵌套结构
        
        尝试多种策略:
        1. 提取 ```json ... ``` 代码块
        2. 直接解析整个响应
        3. 查找第一个 { 到最后一个 }
        """
        # 策略 1: 提取 JSON 代码块 (改进的正则，使用贪婪模式)
        json_match = re.search(r'```json\s*(\{.*\})\s*```', content, re.DOTALL)
        if json_match:
            try:
                return json.loads(json_match.group(1))
            except json.JSONDecodeError as e:
                print(f"⚠️  JSON 代码块解析失败: {e}")
        
        # 策略 2: 尝试直接解析整个内容
        try:
            return json.loads(content.strip())
        except json.JSONDecodeError:
            pass
        
        # 策略 3: 查找第一个 { 到最后一个 }
        first_brace = content.find('{')
        last_brace = content.rfind('}')
        
        if first_brace != -1 and last_brace != -1 and last_brace > first_brace:
            try:
                json_str = content[first_brace:last_brace + 1]
                return json.loads(json_str)
            except json.JSONDecodeError as e:
                print(f"⚠️  提取 JSON 失败: {e}")
        
        return None
    
    def extract_code_from_response(self, content: str) -> Optional[str]:
        """
        从 LLM 响应中提取 Dafny 代码
        
        支持多种格式:
        1. ```dafny ... ```
        2. ```java ... ``` (有时 LLM 会错误标记)
        3. ``` ... ``` (无语言标记)
        4. 直接的代码文本
        """
        # 尝试提取 dafny 代码块
        dafny_match = re.search(r'```dafny\s*(.*?)\s*```', content, re.DOTALL)
        if dafny_match:
            return dafny_match.group(1).strip()
        
        # 尝试提取 java 代码块 (LLM 有时会混淆)
        java_match = re.search(r'```java\s*(.*?)\s*```', content, re.DOTALL)
        if java_match:
            code = java_match.group(1).strip()
            # 检查是否是 Dafny 代码
            if 'method' in code or 'function' in code or 'requires' in code:
                return code
        
        # 尝试提取任意代码块
        code_match = re.search(r'```\s*(.*?)\s*```', content, re.DOTALL)
        if code_match:
            code = code_match.group(1).strip()
            # 检查是否是 Dafny 代码
            if 'method' in code or 'function' in code:
                return code
        
        # 如果都失败了，尝试查找以 "method" 或 "function" 开头的内容
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
        """
        在修复前先分析代码
        """
        print("\n" + "=" * 70)
        print("第一步: 代码分析")
        print("=" * 70)
        
        prompt = PromptTemplates.get_analysis_prompt(code, errors)
        
        try:
            response = self.llm.invoke(prompt)
            content = response.content
            
            # 使用改进的 JSON 提取方法
            analysis = self.extract_json_from_llm_response(content)
            
            if analysis:
                print(f"\n📊 代码意图: {analysis.get('intent', 'N/A')}")
                print(f"📊 算法: {analysis.get('algorithm', 'N/A')}")
                print(f"📊 错误根因: {analysis.get('error_root_cause', 'N/A')}")
                print(f"📊 难度评估: {analysis.get('difficulty', 'N/A')}")
                print(f"📊 建议方向: {analysis.get('suggested_approach', 'N/A')}")
                return analysis
            else:
                print("⚠️  无法解析分析结果，使用默认值")
                print(f"📝 原始响应 (前 500 字符):\n{content[:500]}...")
                return {'difficulty': 'medium'}
                
        except Exception as e:
            print(f"⚠️  代码分析失败: {e}")
            return {'difficulty': 'medium'}
    
    def format_cases(self, cases: List[Document]) -> str:
        """格式化案例"""
        if not cases:
            return "无相似案例"
        
        formatted = []
        for i, doc in enumerate(cases, 1):
            metadata = doc.metadata
            content = doc.page_content
            
            # 尝试解析 JSON
            try:
                case_data = json.loads(content)
                buggy = case_data.get('buggy_code', 'N/A')
                fixed = case_data.get('fixed_code', 'N/A')
                errors = case_data.get('verifier_errors', [])
                
                case_text = f"""
### 案例 {i} (Task: {metadata.get('task_id', 'N/A')})

**原始错误**:
{errors[0] if errors else 'N/A'}

**修复前代码片段**:
```dafny
{buggy}...
```

**修复后代码片段**:
```dafny
{fixed}...
```
"""
            except:
                case_text = f"""
### 案例 {i}
{content[:500]}...
"""
            
            formatted.append(case_text)
        
        return "\n".join(formatted)
    
    def format_auxiliary_docs(self, docs: List[Document]) -> str:
        """格式化辅助文档"""
        if not docs:
            return "无相关文档"
        
        formatted = []
        for i, doc in enumerate(docs, 1):
            formatted.append(f"### 知识 {i}\n{doc.page_content[:800]}...\n")
        
        return "\n".join(formatted)
    
    def generate_first_fix(
        self,
        buggy_code: str,
        verifier_errors: List[str]
    ) -> Dict:
        """
        生成首次修复 - 改进的解析逻辑
        """
        print("\n" + "=" * 70)
        print("第二步: 错误分类")
        print("=" * 70)
        
        # 1. 错误分类
        error_analysis = self.error_classifier.classify_errors(verifier_errors)
        primary_type = error_analysis['primary_type']
        type_counts = error_analysis['type_counts']
        
        print(f"\n🔍 主要错误类型: {primary_type.value}")
        print(f"🔍 错误类型统计:")
        for etype, count in type_counts.items():
            desc = self.error_classifier.get_error_description(etype)
            print(f"   - {desc}: {count} 个")
        
        # 添加类型描述到分析结果
        error_analysis['type_description'] = self.error_classifier.get_error_description(primary_type)
        
        print("\n" + "=" * 70)
        print("第三步: 智能检索")
        print("=" * 70)
        
        # 2. 智能检索
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
        print("第四步: 生成修复方案")
        print("=" * 70)
        
        # 3. 格式化检索结果
        similar_cases = self.format_cases(case_docs)
        auxiliary_knowledge = self.format_auxiliary_docs(auxiliary_docs)
        
        # ======================= 新增代码开始 =======================
        print("\n" + "↓" * 30 + " 检索到的相似案例 " + "↓" * 30)
        print(similar_cases)
        print("-" * 70)
        print("↓" * 30 + " 检索到的辅助文档 " + "↓" * 30)
        print(f"来源: {auxiliary_source}")
        print(auxiliary_knowledge)
        print("↑" * 30 + " 检索内容结束 " + "↑" * 30 + "\n")
        # ======================= 新增代码结束 =======================
        
        # 4. 构建 Prompt
        prompt = PromptTemplates.get_first_fix_prompt(
            buggy_code,
            verifier_errors,
            error_analysis,
            similar_cases,
            auxiliary_knowledge,
            auxiliary_source
        )
        
        # 5. 调用 LLM
        print("\n🤖 调用 LLM 生成修复代码...")
        
        try:
            response = self.llm.invoke(prompt)
            content = response.content
            
            # 尝试解析 JSON
            result = self.extract_json_from_llm_response(content)
            
            if result and 'fixed_code' in result:
                print("✓ 成功解析 LLM 响应")
                print(f"📝 理解: {result.get('understanding', 'N/A')[:100]}...")
                print(f"📝 错误原因: {result.get('error_cause', 'N/A')[:100]}...")
                print(f"📝 修复策略: {result.get('fix_strategy', 'N/A')[:100]}...")
                
                return {
                    'fixed_code': result['fixed_code'],
                    'understanding': result.get('understanding', ''),
                    'error_cause': result.get('error_cause', ''),
                    'fix_strategy': result.get('fix_strategy', ''),
                    'key_changes': result.get('key_changes', []),
                    'error_analysis': error_analysis
                }
            else:
                # 尝试提取代码
                print("⚠️  无法解析 JSON，尝试直接提取代码...")
                print(f"📝 原始响应 (前 500 字符):\n{content[:500]}...")
                
                code = self.extract_code_from_response(content)
                
                if code:
                    print("✓ 成功提取代码")
                    return {
                        'fixed_code': code,
                        'understanding': 'Failed to parse',
                        'error_cause': 'Failed to parse',
                        'fix_strategy': 'Failed to parse',
                        'key_changes': ['Code extracted from response'],
                        'error_analysis': error_analysis
                    }
                else:
                    print("✗ 无法提取代码，使用原始代码")
                    return {
                        'fixed_code': buggy_code,
                        'understanding': 'Parse failed',
                        'error_cause': 'Parse failed',
                        'fix_strategy': 'Parse failed',
                        'key_changes': [],
                        'error_analysis': error_analysis
                    }
                    
        except Exception as e:
            print(f"✗ 生成修复失败: {e}")
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
        """
        生成迭代修复 - 改进的解析逻辑
        """
        print("\n" + "=" * 70)
        print("第二步: 错误分类")
        print("=" * 70)
        
        # 错误分类
        error_analysis = self.error_classifier.classify_errors(current_errors)
        primary_type = error_analysis['primary_type']
        type_counts = error_analysis['type_counts']
        
        print(f"\n🔍 主要错误类型: {primary_type.value}")
        print(f"🔍 错误类型统计:")
        for etype, count in type_counts.items():
            desc = self.error_classifier.get_error_description(etype)
            print(f"   - {desc}: {count} 个")
        
        error_analysis['type_description'] = self.error_classifier.get_error_description(primary_type)
        
        print("\n" + "=" * 70)
        print("第三步: 构建迭代 Prompt")
        print("=" * 70)
        
        # 构建 Prompt
        prompt = PromptTemplates.get_iterative_fix_prompt(
            current_code,
            current_errors,
            iteration,
            previous_attempts,
            error_analysis
        )
        
        print("\n🤖 调用 LLM 生成修复代码...")
        
        try:
            response = self.llm.invoke(prompt)
            content = response.content
            
            # 尝试解析 JSON
            result = self.extract_json_from_llm_response(content)
            
            if result and 'fixed_code' in result:
                print("✓ 成功解析 LLM 响应")
                print(f"📝 反思: {result.get('reflection', 'N/A')[:100]}...")
                print(f"📝 新策略: {result.get('new_strategy', 'N/A')[:100]}...")
                
                return {
                    'fixed_code': result['fixed_code'],
                    'reflection': result.get('reflection', ''),
                    'new_strategy': result.get('new_strategy', ''),
                    'key_changes': result.get('key_changes', []),
                    'error_analysis': error_analysis
                }
            else:
                # 尝试提取代码
                print("⚠️  无法解析 JSON，尝试直接提取代码...")
                print(f"📝 原始响应 (前 500 字符):\n{content[:500]}...")
                
                code = self.extract_code_from_response(content)
                
                if code:
                    print("✓ 成功提取代码")
                    return {
                        'fixed_code': code,
                        'reflection': 'Failed to parse',
                        'new_strategy': 'Failed to parse',
                        'key_changes': ['Code extracted from response'],
                        'error_analysis': error_analysis
                    }
                else:
                    print("✗ 无法提取代码，使用当前代码")
                    return {
                        'fixed_code': current_code,
                        'reflection': 'Parse failed',
                        'new_strategy': 'Parse failed',
                        'key_changes': [],
                        'error_analysis': error_analysis
                    }
        
        except Exception as e:
            print(f"✗ 迭代修复失败: {e}")
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
        """保存修复后的代码"""
        filename = f"task_id_{task_id}-iter_{iteration}-fixed.dfy"
        filepath = os.path.join(self.output_dir, filename)
        
        with open(filepath, "w", encoding="utf-8") as f:
            f.write(fixed_code)
        
        print(f"✓ 代码已保存: {filepath}")
        return filepath
    
    def verify_dafny_code(
        self, dfy_file_path: str, timeout: int = 60
    ) -> tuple[int, int, str]:
        """
        验证 Dafny 代码
        
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
            print(f"⏱️  验证超时 (>{timeout}s)")
            return (0, -1, "Timeout")
        except CalledProcessError as e:
            cmd_output = e.output
        except FileNotFoundError:
            print("✗ Dafny 未安装")
            return (0, -2, "Dafny not found")
        except Exception as e:
            print(f"✗ 验证失败: {e}")
            return (0, -2, str(e))
        
        # 解析输出
        verification_count = 0
        error_count = 0
        
        # 首先检查是否有 parse errors (语法错误)
        parse_error_match = re.search(r'(\d+)\s+parse\s+errors?', cmd_output, re.IGNORECASE)
        if parse_error_match:
            error_count = int(parse_error_match.group(1))
            verification_count = 0
            return (verification_count, error_count, cmd_output)
        
        # 检查验证统计行: "X verified, Y errors"
        for line in cmd_output.split('\n'):
            # 提取验证成功的数量
            if 'verified' in line.lower():
                match = re.search(r'(\d+)\s+verified', line, re.IGNORECASE)
                if match:
                    verification_count = int(match.group(1))
            
            # 提取错误数量 - 从 "X errors" 格式提取
            error_match = re.search(r'(\d+)\s+errors?', line, re.IGNORECASE)
            if error_match:
                error_count = int(error_match.group(1))
                break  # 找到错误统计就停止
        
        # 如果没有找到统计,手动计数 "Error:" 行
        if error_count == 0 and verification_count == 0:
            for line in cmd_output.split('\n'):
                line_stripped = line.strip()
                if (': Error:' in line_stripped or 
                    line_stripped.startswith('Error:') or 
                    line_stripped.startswith('error:')):
                    error_count += 1
        
        return (verification_count, error_count, cmd_output)
    
    def parse_verifier_errors(self, output: str) -> List[str]:
        """从验证器输出中提取错误信息"""
        errors = []
        for line in output.split('\n'):
            line = line.strip()
            # 改进：兼容 "file(x,y): Error:" 格式和 "Error:" 开头的格式
            if (': Error:' in line) or (': error:' in line) or \
               line.startswith('Error:') or line.startswith('error:'):
                errors.append(line)
        
        # 如果没有提取到标准错误，尝试提取其它相关信息作为兜底
        if not errors and "errors" in output.lower():
             # 提取包含 failure 或 violation 的行作为替补
            for line in output.split('\n'):
                if any(k in line.lower() for k in ['violation', 'failure', 'could not be proved']):
                    errors.append(line.strip())

        return errors if errors else []
    
    def save_verification_log(
        self, task_id: str, cmd_output: str, iteration: int = 1
    ) -> str:
        """保存验证日志"""
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
        """
        完整的迭代修复流程
        """
        print("\n" + "=" * 70)
        print(f"开始迭代修复流程 (最大 {max_iterations} 次)")
        print("=" * 70)
        
        # 确保知识库已加载
        if self.case_db is None:
            print("\n⚠️  知识库未加载，正在加载...")
            self.load_all_vectorstores()
        
        # 代码分析
        analysis = self.analyze_code(buggy_code, verifier_errors)
        
        # 修复历史
        fix_history = []
        current_code = buggy_code
        current_errors = verifier_errors
        
        for iteration in range(1, max_iterations + 1):
            print("\n" + "=" * 70)
            print(f"迭代 {iteration}/{max_iterations}")
            print("=" * 70)
            
            # 生成修复
            if iteration == 1:
                fix_result = self.generate_first_fix(current_code, current_errors)
            else:
                fix_result = self.generate_iterative_fix(
                    current_code,
                    current_errors,
                    iteration,
                    fix_history
                )
            
            # 保存代码
            dfy_path = self.save_fixed_code(task_id, fix_result['fixed_code'], iteration)
            
            # 验证代码
            print(f"\n🔍 验证修复后的代码...")
            verification_count, error_count, verification_output = self.verify_dafny_code(dfy_path)
            
            log_path = self.save_verification_log(task_id, verification_output, iteration)
            
            # 记录本次尝试
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
            
            # 添加分析信息
            if iteration == 1:
                iteration_record['understanding'] = fix_result.get('understanding', '')
                iteration_record['error_cause'] = fix_result.get('error_cause', '')
                iteration_record['fix_strategy'] = fix_result.get('fix_strategy', '')
            else:
                iteration_record['reflection'] = fix_result.get('reflection', '')
                iteration_record['new_strategy'] = fix_result.get('new_strategy', '')
            
            fix_history.append(iteration_record)
            
            # 显示结果和判断成功
            # 成功条件: 必须有验证通过项 且 没有错误
            is_truly_successful = (error_count == 0 and verification_count > 0)
            
            if is_truly_successful:
                print(f"\n{'✓' * 35}")
                print(f"🎉 修复成功! 第 {iteration} 次尝试通过验证!")
                print(f"   通过: {verification_count} 项")
                print(f"{'✓' * 35}")
                break
            elif error_count == 0 and verification_count == 0:
                # 没有验证通过项,也没有错误 - 可能是解析失败或空文件
                print(f"\n⚠️  验证结果异常 (第 {iteration} 次尝试)")
                print(f"   无法确定验证状态 (verified=0, errors=0)")
                print(f"   请手动检查: {log_path}")
                # 视为失败,继续尝试
                if iteration >= max_iterations:
                    print(f"\n⚠️  已达最大迭代次数")
                    break
            elif error_count == -1:
                print(f"\n⏱️  验证超时")
                break
            elif error_count == -2:
                print(f"\n✗ 验证失败")
            else:
                print(f"\n✗ 仍有 {error_count} 个错误")
                print(f"   通过: {verification_count} 项")
                
                if iteration < max_iterations:
                    print(f"\n➡️  继续第 {iteration + 1} 次尝试...")
                    current_code = fix_result['fixed_code']
                    current_errors = self.parse_verifier_errors(verification_output)
                else:
                    print(f"\n⚠️  已达最大迭代次数")
        
        # 返回结果
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


# 为了兼容性，添加 subprocess 导入
import subprocess