Method Signature:
method MaxUppercaseRun(s: string) returns (maxRun: nat)

Postconditions_prompt:
- The returned maxRun is the length of the longest consecutive sequence of uppercase characters in the input string
- For every position in the string, the maximum run length does not exceed maxRun
- If the string contains no uppercase characters, then maxRun is zero