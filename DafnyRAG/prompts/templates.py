"""
优化的 Prompt 模板 - 精简版（无 Few-shot 示例）
版本: v2.2
"""

from typing import List, Dict


class PromptTemplates:
    """优化的 Prompt 模板集合"""

    @staticmethod
    def get_first_fix_prompt(
        buggy_code: str,
        verifier_errors: List[str],
        error_analysis: Dict,
        similar_cases: str,
        auxiliary_knowledge: str,
        auxiliary_source: str,
    ) -> str:
        """
        首次修复的 Prompt - 精简版本
        """
        
        primary_type = error_analysis["primary_type"]
        type_description = error_analysis.get("type_description", "")
        
        # 错误类型特定的指导
        specific_guidance = PromptTemplates._get_error_specific_guidance(primary_type)
        
        # 构建错误信息
        error_info = verifier_errors[0]
        if len(verifier_errors) > 1:
            error_extra = f"\n...还有 {len(verifier_errors) - 1} 个错误"
            error_info = error_info + error_extra
        
        # 构建辅助知识部分
        auxiliary_section = ""
        if auxiliary_knowledge and auxiliary_knowledge != '无相关文档':
            auxiliary_section = f"\n# 专业知识 (来源: {auxiliary_source})\n\n{auxiliary_knowledge}"
        
        prompt = f"""你是 Dafny 形式化验证专家。请修复以下代码的验证错误。

# 错误分析

**错误类型**: {type_description}

**错误信息**:
```
{error_info}
```

# 错误代码

```dafny
{buggy_code}
```

# 修复指导

{specific_guidance}

# 相似案例参考

{similar_cases}
{auxiliary_section}

# 输出要求

**请严格按照以下 JSON 格式输出**（不要有任何其他文字）:

```json
{{
  "thinking": "你的分析思路(2-3句话，说明为什么会出错)",
  "fix_strategy": "修复策略(1-2句话，说明打算怎么修)",
  "key_changes": [
    "具体改动1",
    "具体改动2"
  ],
  "fixed_code": "完整的修复后代码"
}}
```

**重要提示**:
1. fixed_code 必须是完整的、可以直接运行的代码
2. 保持原有代码结构，只修复验证问题
3. 不要添加不必要的功能
4. 如果需要添加 invariant 或 decreases，确保它们是精确的
5. 输出必须是纯 JSON，不要包含 markdown 标记
"""
        return prompt

    @staticmethod
    def _get_error_specific_guidance(error_type) -> str:
        """根据错误类型返回具体的修复指导"""
        
        # 动态导入避免循环依赖
        try:
            from core.error_classifier import ErrorType
        except:
            return """
## 通用修复建议

1. 仔细分析错误信息，定位具体问题
2. 参考相似案例，学习修复模式
3. 从简单开始，逐步加强规约
4. 使用断言帮助 Dafny 理解推理过程
"""
        
        guidance = {
            ErrorType.LOOP_INVARIANT: """
## 循环不变量修复技巧

**不变量的三要素**:
1. **范围约束**: 循环变量的有效范围
   - 例: `0 <= i <= n`, `1 <= j < a.Length`

2. **累积属性**: 已处理部分的性质
   - 例: `forall k :: 0 <= k < i ==> a[k] <= a[k+1]` (前i个已排序)
   - 例: `sum == sum(a[0..i])` (sum 是前i个元素之和)

3. **目标进展**: 距离目标的关系
   - 例: `found ==> a[result] == key` (如果找到，result是正确的)

**检查清单**:
- [ ] 循环开始前不变量成立吗？
- [ ] 循环体执行后不变量保持吗？
- [ ] 循环结束时能推导出后置条件吗？
""",
            
            ErrorType.TERMINATION: """
## 终止性证明技巧

**使用 decreases 子句**:
1. **找到度量函数**: 每次迭代都会减小的量
   - 例: `decreases n - i` (递增循环)
   - 例: `decreases high - low` (二分搜索)
   - 例: `decreases |s|` (集合/序列大小)

2. **确保非负**: 度量必须 >= 0
   - 添加不变量: `invariant i <= n`

3. **严格递减**: 每次迭代度量严格减小
   - 确保: `i := i + 1` 或 `high := mid`
""",
            
            ErrorType.PRECONDITION: """
## 前置条件错误修复

**常见问题**:
1. **调用方法时前置条件不满足**
   - 检查: 调用处是否满足被调用方法的 requires
   - 修复: 添加 assert 或加强当前方法的 requires

2. **数组越界**
   - 确保: `0 <= i < a.Length`
   - 在调用前添加断言验证

3. **除零错误**
   - 确保: `divisor != 0`
   - 添加前置条件或运行时检查
""",
            
            ErrorType.POSTCONDITION: """
## 后置条件错误修复

**修复步骤**:
1. **检查所有退出路径**: 确保每个 return 都满足 ensures
2. **添加辅助断言**: 帮助 Dafny 理解为什么后置条件成立
3. **考虑边界情况**: 空数组、相等情况等
4. **使用 old()**: 引用方法调用前的值
   - 例: `ensures result == old(a[0]) + old(a[1])`
""",
            
            ErrorType.ASSERTION: """
## 断言失败修复

**调试方法**:
1. **检查断言位置**: 断言是否放对了地方？
2. **加强前置条件**: 可能需要在方法开头添加更强的 requires
3. **添加中间断言**: 逐步证明，帮助 Dafny 理解
4. **检查不变量**: 循环不变量是否足够强？
""",
            
            ErrorType.PARSE_ERROR: """
## 语法错误修复

**常见语法问题**:
1. **不变量语法**: 使用 `forall` 而不是 `for all`
   - 正确: `forall k :: 0 <= k < n ==> P(k)`
   - 错误: `for all k in 0..n: P(k)`

2. **表达式语法**: 确保符合 Dafny 规范
   - 使用 `==>` 而不是 `implies`
   - 使用 `<=` 而不是 `≤`

3. **缺少分号或括号**: 检查语法完整性
""",
            
            ErrorType.UNDEFINED_IDENTIFIER: """
## 未定义标识符修复

**检查项**:
1. **拼写错误**: 变量名是否拼写正确？
2. **作用域问题**: 变量是否在当前作用域内？
3. **缺少定义**: 是否需要定义常量或辅助函数？
4. **导入问题**: 是否需要导入其他模块？
""",

            ErrorType.INVALID_EXPRESSION: """
## 无效表达式修复

**常见问题**:
1. **表达式格式错误**: 检查语法是否符合 Dafny 规范
2. **类型不匹配**: 确保表达式类型正确
3. **运算符使用**: 检查运算符是否正确使用
"""
        }
        
        return guidance.get(error_type, """
## 通用修复建议

1. 仔细分析错误信息，定位具体问题
2. 参考相似案例，学习修复模式
3. 从简单开始，逐步加强规约
4. 使用断言帮助 Dafny 理解推理过程
""")

    @staticmethod
    def get_iterative_fix_prompt(
        current_code: str,
        current_errors: List[str],
        iteration: int,
        previous_attempts: List[Dict],
        error_analysis: Dict,
    ) -> str:
        """
        迭代修复的 Prompt - 强调反思和策略调整
        """
        
        # 构建简洁的历史记录
        history_summary = PromptTemplates._build_history_summary(previous_attempts)
        
        primary_type = error_analysis["primary_type"]
        type_description = error_analysis.get("type_description", "")
        
        # 构建错误信息
        error_info = current_errors[0]
        if len(current_errors) > 1:
            error_extra = f"\n...还有 {len(current_errors) - 1} 个错误"
            error_info = error_info + error_extra
        
        prompt = f"""你是 Dafny 专家。这是第 {iteration} 次修复尝试。

# 历史回顾

{history_summary}

# 当前状态

**错误类型**: {type_description}

**当前错误**:
```
{error_info}
```

**当前代码**:
```dafny
{current_code}
```

# 反思与改进

## 第一步: 分析失败原因

之前的尝试为什么失败了？
- 是不变量太弱还是太强？
- 是否引入了新的错误？
- 是否遗漏了边界情况？

## 第二步: 调整策略

**如果连续失败 2 次以上**:
- 考虑简化问题（去掉过强的后置条件）
- 尝试不同的不变量表达方式
- 添加更多辅助断言

**关键原则**:
- 不要重复之前失败的修复方案
- 每次改动要有明确理由
- 从简单开始，逐步加强

# 输出要求

```json
{{
  "reflection": "对之前失败的反思(1-2句话)",
  "new_strategy": "新的修复策略(1-2句话)",
  "key_changes": [
    "本次主要改动1",
    "本次主要改动2"
  ],
  "fixed_code": "完整的修复后代码"
}}
```

**特别注意**:
- 输出必须是纯 JSON
- 不要重复之前失败的方案
- 如果连续失败，考虑简化策略
"""
        return prompt

    @staticmethod
    def _build_history_summary(previous_attempts: List[Dict]) -> str:
        """构建简洁的历史摘要"""
        
        if not previous_attempts:
            return "这是首次尝试"
        
        summary_lines = []
        # 只显示最近3次
        recent_attempts = previous_attempts[-3:] if len(previous_attempts) > 3 else previous_attempts
        
        for i, attempt in enumerate(recent_attempts, 1):
            error_count = attempt.get('error_count', 0)
            key_changes = attempt.get('key_changes', [])
            
            status = "✗ 失败" if error_count > 0 else "✓ 成功"
            changes = ', '.join(key_changes[:2]) if key_changes else "无记录"
            
            summary_lines.append(
                f"**尝试 {i}**: {status} | 错误数: {error_count} | 改动: {changes}"
            )
        
        return '\n'.join(summary_lines)

    @staticmethod
    def get_analysis_prompt(code: str, errors: List[str]) -> str:
        """
        代码分析 Prompt - 简化版本
        """
        
        error_text = errors[0] if errors else "无错误信息"
        
        prompt = f"""作为 Dafny 专家，快速分析以下代码及其错误。

# 代码
```dafny
{code}
```

# 错误
```
{error_text}
```

请简要回答:

```json
{{
  "intent": "代码意图(1句话)",
  "error_cause": "错误根本原因(1句话)",
  "difficulty": "simple/medium/hard",
  "suggested_approach": "建议的修复方向(1句话)"
}}
```

注意: 输出必须是纯 JSON，不要有其他文字。
"""
        return prompt