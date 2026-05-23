Method Signature:
method MaxUppercaseRun(s: string) returns (maxRun: nat)

Postconditions_prompt:
- The returned value maxRun is the length of the longest consecutive sequence of uppercase characters in s
- maxRun is less than or equal to the total number of uppercase characters in s
- If s contains no uppercase characters, then maxRun is zero