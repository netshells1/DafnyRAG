Method Signature:
method ContainsUnderscoreSeparatedLowercaseSequences(s: string) returns (result: bool)

Postconditions_prompt:
- The result is true if and only if the input string consists of one or more sequences of lowercase letters separated by underscores
- If the result is true, every sequence of lowercase letters is properly joined by underscores without any other characters
- If the result is false, the string does not meet the pattern of lowercase sequences separated by underscores