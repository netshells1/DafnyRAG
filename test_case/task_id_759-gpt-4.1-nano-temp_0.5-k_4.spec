Method Signature:
method IsDecimalWithPrecision2(s: string) returns (result: bool)

Postconditions_prompt:
- The result is true if and only if the input string represents a decimal number with up to two digits after the decimal point
- If the result is true, the string conforms to the format of an optional sign, digits, an optional decimal point, and up to two digits after the decimal point
- If the result is false, the string does not match the decimal number format with the specified precision