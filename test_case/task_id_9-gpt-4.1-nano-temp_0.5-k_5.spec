Method Signature:
method MinRotationsToOriginal(s: string) returns (rotations: int)

Postconditions_prompt:
- rotations should be a positive integer greater than 0
    - Rotating the string s by rotations positions results in a string equal to s
    - For all integers k where 1 <= k < rotations, rotating s by k positions does not produce s again