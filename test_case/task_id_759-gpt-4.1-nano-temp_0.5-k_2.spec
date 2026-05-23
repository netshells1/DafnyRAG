Method Signature:
method IsDecimalWithPrecision2(s: string) returns (result: bool)

Postconditions_prompt:
- The result is true if and only if the string represents a decimal number with up to two digits after the decimal point
- The string may optionally start with a '+' or '-' sign
- If the string contains a decimal point, there are at most two digits following it
- The string contains only digits, an optional decimal point, and optional sign at the beginning
- The result is false if the string is not a valid decimal number with the specified precision