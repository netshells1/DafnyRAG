Method Signature:
method MaxUppercaseRun(s: string) returns (maxRun: nat)

Postconditions_prompt:
- The maxRun value is the length of the longest consecutive sequence of uppercase characters in the input string
- For any position i in s, if the sequence of uppercase characters starting at i has length maxRun, then this sequence is the longest run of uppercase characters in s
- If there are no uppercase characters in s, then maxRun is zero