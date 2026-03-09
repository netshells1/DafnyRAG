Method Signature:
method MinRotationsToSameString(s: string) returns (rotations: int)

Postconditions_prompt:
- rotations is greater than 0
- Rotating the string s by rotations positions results in a string equal to s
- For all rotations less than rotations, rotating s by that amount does not produce s again