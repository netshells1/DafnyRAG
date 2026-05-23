"""
Enhanced Prompt Templates - Guide the LLM to better understand and fix code
"""

from typing import List, Dict


class PromptTemplates:
    """Collection of prompt templates"""

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
        Prompt for the first fix attempt - includes code understanding and reasoning steps
        """

        primary_type = error_analysis["primary_type"]
        type_description = error_analysis.get("type_description", "")

        prompt = f"""You are a Dafny formal verification expert. Your task is to fix the verification errors in the Dafny code below.

# Current Error Analysis

**Primary Error Type**: {primary_type.value}
**Error Description**: {type_description}

**All Error Messages**:
{chr(10).join([f"  {i+1}. {err}" for i, err in enumerate(verifier_errors)])}

# Buggy Code

```dafny
{buggy_code}
```

# Reference Knowledge

## Similar Cases ({len(similar_cases)})
The following are fix examples for similar errors. Use them as reference for your repair strategy:

{similar_cases}

## Domain Knowledge (Source: {auxiliary_source})
{auxiliary_knowledge}

# Fix Guidelines

Please follow these steps to perform the fix:

## Step 1: Understand the Code Intent
1. What functionality is this code trying to implement?
2. What are the meanings and constraints of the input parameters?
3. What is the expected output?

## Step 2: Analyze the Root Cause
1. Why does the current error occur?
2. Is it a logic problem or an incomplete specification?
3. If it is a verification error, why can't the Dafny verifier prove the code correct?

## Step 3: Devise a Fix Strategy
Choose an appropriate fix strategy based on the error type:

- **If it is a loop invariant error**:
  * Analyze what the loop does and what remains unchanged after each iteration
  * The invariant should describe: the initial state + the cumulative effect of each iteration
  * Ensure the invariant holds before the loop starts and is maintained after every iteration

- **If it is a termination proof error**:
  * Find a measure that decreases with each iteration (usually the distance to the target)
  * Use a `decreases` clause to explicitly state this measure

- **If it is a postcondition error**:
  * Check whether additional assertions are needed to assist the proof
  * Ensure all branches satisfy the postcondition

- **If it is a precondition error**:
  * Check whether the call site satisfies the callee's precondition
  * You may need to add assertions before the call or strengthen the current method's precondition

- **If it is an undefined identifier**:
  * Check for spelling mistakes
  * Confirm whether the required constant, function, or method has been defined
  * If a mathematical constant (e.g. Pi) is needed, consider defining it as a constant or using an approximation

## Step 4: Generate the Fixed Code
Based on the analysis above, produce the complete fixed code.

# Output Format

Please output strictly in the following JSON format:

```json
{{
  "understanding": "Your understanding of the code intent (2-3 sentences)",
  "error_cause": "The root cause of the error (2-3 sentences)",
  "fix_strategy": "Your fix strategy (2-3 sentences)",
  "key_changes": [
    "Key change 1",
    "Key change 2"
  ],
  "fixed_code": "The complete fixed code (preserve original formatting)"
}}
```

**Important Notes**:
1. Do not alter the core logic or functionality of the code
2. Only fix verification issues; do not add unnecessary features
3. Ensure the fixed code is complete and runnable
4. Maintain consistent code style and indentation
5. If invariants or decreases clauses need to be added, make sure they are precise
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
        Prompt for iterative fix attempts - includes reflection on previous history
        """

        # Build history summary
        history_text = "## Previous Fix Attempts\n\n"
        for i, attempt in enumerate(previous_attempts, 1):
            history_text += f"### Attempt {i}\n"
            history_text += f"- Error count: {attempt['error_count']}\n"
            if attempt.get("key_changes"):
                history_text += f"- Key changes: {', '.join(attempt['key_changes'])}\n"
            if attempt["error_count"] > 0:
                history_text += (
                    f"- Remaining issues: {attempt['verification_output'][:200]}...\n"
                )
            history_text += "\n"

        primary_type = error_analysis["primary_type"]
        type_description = error_analysis.get("type_description", "")

        prompt = f"""You are a Dafny formal verification expert. This is fix attempt number {iteration}.

# Fix History

{history_text}

# Current State

**Current Error Type**: {primary_type.value}
**Error Description**: {type_description}

**Current Code**:
```dafny
{current_code}
```

**Current Error Messages**:
{chr(10).join([f"  {i+1}. {err}" for i, err in enumerate(current_errors)])}

# Reflection and Improvement

Please reflect on the previous failed attempts:

## Step 1: Analyze Why Previous Attempts Failed
1. What went wrong with the previous fix attempts?
2. Why did those changes fail to resolve the problem?
3. Were any new errors introduced?

## Step 2: Adjust the Strategy
1. Is a different angle needed?
2. Should certain specifications be strengthened or weakened?
3. Are auxiliary assertions needed to help Dafny understand the proof?

## Step 3: Generate a New Fix
Based on the reflection above, produce an improved fixed version of the code.

# Output Format

```json
{{
  "reflection": "Reflection on previous failures (2-3 sentences)",
  "new_strategy": "New fix strategy (2-3 sentences)",
  "key_changes": [
    "Key change in this attempt 1",
    "Key change in this attempt 2"
  ],
  "fixed_code": "The complete fixed code"
}}
```

**Special Notes**:
- Do not repeat previously failed fix approaches
- If failures persist, consider simplifying the problem (e.g. relaxing an overly strong postcondition)
- Every change should have a clear rationale
"""
        return prompt

    @staticmethod
    def get_analysis_prompt(code: str, errors: List[str]) -> str:
        """
        Code analysis prompt - understand the code before attempting a fix
        """
        prompt = f"""As a Dafny expert, please analyze the following code and its errors.

# Code
```dafny
{code}
```

# Error Messages
{chr(10).join([f"  {i+1}. {err}" for i, err in enumerate(errors)])}

Please answer the following questions:

1. **Code Intent**: What functionality is this code trying to implement?
2. **Algorithm Logic**: What algorithm or approach is used?
3. **Error Root Cause**: What is the fundamental cause of the verification error?
4. **Fix Difficulty**: Is this problem simple, medium, or hard?

Output in JSON format:
```json
{{
  "intent": "Code intent",
  "algorithm": "Algorithm description",
  "error_root_cause": "Root cause of the error",
  "difficulty": "simple/medium/hard",
  "suggested_approach": "Suggested fix direction"
}}
```
"""
        return prompt