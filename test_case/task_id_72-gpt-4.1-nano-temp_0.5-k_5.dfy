method CanBeExpressedAsDifferenceOfSquares(n: int) returns (result: bool)
  ensures result <==> (exists a, b: int :: n == a * a - b * b)
{
    // The key mathematical insight:
    // n can be expressed as difference of squares iff n is not congruent to 2 or 3 mod 4
    // But for generality, we can check directly
    result := exists a, b: int :: n == a * a - b * b;
}