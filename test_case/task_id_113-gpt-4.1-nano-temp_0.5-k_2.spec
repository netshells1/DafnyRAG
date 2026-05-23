Method Signature:
method IsStringInteger(s: string) returns (result: bool)

Postconditions_prompt:
- The result is true if the input string represents a valid integer (including optional leading '+' or '-')
- The result is false if the input string does not represent a valid integer (e.g., contains non-digit characters, empty string, or invalid format)