method IsDifferenceOfSquares(n: int) returns (result: bool)
    ensures result <==> (exists a: int, b: int :: n == a * a - b * b)
{
    // For n >= 0, a possible representation exists if n is not congruent to 2 mod 4
    // For n < 0, always possible by choosing suitable a and b
    if n < 0 {
        // Any negative number can be expressed as (a)^2 - (b)^2 with suitable a, b
        // For example, n = -k, with a = 0, b = sqrt(k) (not necessarily integer), so we need a different approach
        // But since we need integers, let's check the known characterization:
        // Numbers congruent to 0, 1, 3 mod 4 can be expressed as difference of squares
        // Numbers congruent to 2 mod 4 cannot
        // So, for n < 0, always true
        result := true;
    } else {
        // n >= 0
        // n can be expressed as difference of squares iff n mod 4 != 2
        result := (n % 4 != 2);
    }
}