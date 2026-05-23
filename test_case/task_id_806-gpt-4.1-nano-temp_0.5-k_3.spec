Method Signature:
method MaxUppercaseRun(s: string) returns (maxRun: nat)

Postconditions_prompt:
- The returned value maxRun is the length of the longest consecutive sequence of uppercase characters in the input string s
    - For any position i in s, if there exists a sequence of consecutive uppercase characters of length maxRun, then this sequence occurs somewhere in s