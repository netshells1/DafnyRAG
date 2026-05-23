Method Signature:
method ContainsLowercaseUnderscoreSequence(s: string) returns (result: bool)

Postconditions_prompt:
- The result is true if and only if the input string contains at least one sequence of one or more lowercase letters directly followed by an underscore and then another sequence of one or more lowercase letters
    - The result is false if no such pattern exists in the input string