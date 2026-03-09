"""
增强的 Prompt 模板 - 引导 LLM 更好地理解和修复代码
"""

from typing import List, Dict


class PromptTemplates:
    """Prompt 模板集合"""

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
        首次修复的 Prompt - 包含代码理解和推理步骤
        """

        primary_type = error_analysis["primary_type"]
        type_description = error_analysis.get("type_description", "")

        prompt = f"""你是一个 Dafny 形式化验证专家。你的任务是修复下面的 Dafny 代码验证错误。

# 当前错误分析

**主要错误类型**: {primary_type.value}
**错误描述**: {type_description}

**所有错误信息**:
{chr(10).join([f"  {i+1}. {err}" for i, err in enumerate(verifier_errors)])}

# 错误代码

```dafny
{buggy_code}
```

# 参考知识

## 相似案例 ({len(similar_cases)} 个)
以下是类似错误的修复案例，可以参考其修复思路:

{similar_cases}

## 专业知识 (来源: {auxiliary_source})
{auxiliary_knowledge}

# 修复指导

请按照以下步骤进行修复:

## 第一步: 理解代码意图
1. 这段代码想要实现什么功能?
2. 输入参数的含义和约束是什么?
3. 预期的输出结果是什么?

## 第二步: 分析错误原因
1. 为什么会出现当前的错误?
2. 是逻辑问题还是规约不完整?
3. 如果是验证错误，Dafny 验证器为什么无法证明代码正确?

## 第三步: 制定修复策略
根据错误类型选择合适的修复策略:

- **如果是循环不变量错误**: 
  * 分析循环做了什么，以及每次迭代后什么保持不变
  * 不变量应该描述: 初始状态 + 每次迭代的累积效果
  * 确保不变量在循环开始前成立，并且每次迭代后都保持成立
  
- **如果是终止性证明错误**:
  * 找到一个随迭代递减的度量(通常是到目标的距离)
  * 使用 `decreases` 子句显式说明这个度量
  
- **如果是后置条件错误**:
  * 检查是否需要添加额外的断言来辅助证明
  * 确保所有分支都满足后置条件
  
- **如果是前置条件错误**:
  * 检查调用处是否满足被调用方法的前置条件
  * 可能需要在调用前添加断言或加强当前方法的前置条件

- **如果是未定义标识符**:
  * 检查是否拼写错误
  * 确认需要的常量、函数或方法是否已定义
  * 如果需要数学常量(如 Pi)，考虑定义为常量或使用近似值

## 第四步: 生成修复代码
基于上述分析，生成修复后的完整代码。

# 输出格式

请严格按照以下 JSON 格式输出:

```json
{{
  "understanding": "你对代码意图的理解(2-3句话)",
  "error_cause": "错误产生的根本原因(2-3句话)",
  "fix_strategy": "你的修复策略(2-3句话)",
  "key_changes": [
    "主要改动1",
    "主要改动2"
  ],
  "fixed_code": "完整的修复后的代码(保持原有格式)"
}}
```

**重要提示**:
1. 不要改变代码的核心逻辑和功能
2. 只修复验证问题，不要添加不必要的功能
3. 确保修复后的代码完整可运行
4. 保持代码风格和缩进格式一致
5. 如果需要添加 invariant 或 decreases，请确保它们是精确的
"""
        return prompt

    @staticmethod
    def get_iterative_fix_prompt(
        current_code: str,
        current_errors: List[str],
        iteration: int,
        previous_attempts: List[Dict],
        error_analysis: Dict,
    ) -> str:
        """
        迭代修复的 Prompt - 包含历史反思
        """

        # 构建历史分析
        history_text = "## 之前的修复尝试\n\n"
        for i, attempt in enumerate(previous_attempts, 1):
            history_text += f"### 第 {i} 次尝试\n"
            history_text += f"- 错误数量: {attempt['error_count']}\n"
            if attempt.get("key_changes"):
                history_text += f"- 主要改动: {', '.join(attempt['key_changes'])}\n"
            if attempt["error_count"] > 0:
                history_text += (
                    f"- 仍然存在的问题: {attempt['verification_output'][:200]}...\n"
                )
            history_text += "\n"

        primary_type = error_analysis["primary_type"]
        type_description = error_analysis.get("type_description", "")

        prompt = f"""你是一个 Dafny 形式化验证专家。这是第 {iteration} 次修复尝试。

# 修复历史回顾

{history_text}

# 当前状态

**当前错误类型**: {primary_type.value}
**错误描述**: {type_description}

**当前代码**:
```dafny
{current_code}
```

**当前错误信息**:
{chr(10).join([f"  {i+1}. {err}" for i, err in enumerate(current_errors)])}

# 反思与改进

请基于之前的失败经验进行反思:

## 第一步: 分析之前为什么失败
1. 之前的修复尝试有什么问题?
2. 为什么那些改动没有解决问题?
3. 是否引入了新的错误?

## 第二步: 调整策略
1. 需要换一个角度吗?
2. 是否需要加强/削弱某些规约?
3. 是否需要添加辅助断言来帮助 Dafny 理解?

## 第三步: 生成新的修复方案
基于反思，生成改进的修复代码。

# 输出格式

```json
{{
  "reflection": "对之前失败的反思(2-3句话)",
  "new_strategy": "新的修复策略(2-3句话)",
  "key_changes": [
    "本次主要改动1",
    "本次主要改动2"
  ],
  "fixed_code": "完整的修复后的代码"
}}
```

**特别注意**:
- 不要重复之前失败的修复方案
- 如果连续失败，考虑简化问题(如去掉过强的后置条件)
- 确保每次改动都有明确的理由
"""
        return prompt

    @staticmethod
    def get_analysis_prompt(code: str, errors: List[str]) -> str:
        """
        代码分析 Prompt - 在修复前先理解代码
        """
        prompt = f"""作为 Dafny 专家，请分析以下代码及其错误。

# 代码
```dafny
{code}
```

# 错误信息
{chr(10).join([f"  {i+1}. {err}" for i, err in enumerate(errors)])}

请回答以下问题:

1. **代码意图**: 这段代码想要实现什么功能?
2. **算法逻辑**: 使用了什么算法或方法?
3. **错误本质**: 验证错误的根本原因是什么?
4. **修复难度**: 这个问题是简单(simple)、中等(medium)还是困难(hard)?

以 JSON 格式输出:
```json
{{
  "intent": "代码意图",
  "algorithm": "算法描述",
  "error_root_cause": "错误根本原因",
  "difficulty": "simple/medium/hard",
  "suggested_approach": "建议的修复方向"
}}
```
"""
        return prompt
