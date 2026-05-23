Method Signature:
method ContainsUnderscoreSeparatedLowercaseSequences(s: string) returns (result: bool)

Postconditions_prompt:
- The method returns true if and only if the input string consists of one or more sequences of lowercase letters separated by underscores
- If the method returns true, every underscore in the string is directly preceded and followed by a sequence of lowercase letters
- If the method returns false, the string does not follow the pattern of lowercase sequences joined by underscores