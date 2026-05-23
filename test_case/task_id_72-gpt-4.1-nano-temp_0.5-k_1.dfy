method CanBeExpressedAsDifferenceOfSquares(n: int) returns (result: bool)
    ensures result <==> exists a, b: int :: n == a * a - b * b
{
    // For any integer n, it can be represented as a difference of two squares 
    // if and only if n is not congruent to 2 modulo 4.
    // But since the postcondition explicitly states the existence, we can directly check:
    // For simplicity, attempt all possible a, b within bounds (bounded search)
    // Alternatively, use the known characterization:
    // n == a^2 - b^2 = (a - b)(a + b)
    // So, n can be expressed as a difference of squares iff n != 2 mod 4, except for n=0.
    // But for verification, we can implement a direct check.

    // Implementation:
    // Since the problem is about verification, we can implement a straightforward check.

    var found := false;
    var maxAbs := if n >= 0 then n else -n;
    var limit := maxAbs + 1;
    var a, b: int;

    result := false;
    for a := -limit to limit
        invariant -limit <= a <= limit
        decreases a
    {
        for b := -limit to limit
            invariant -limit <= b <= limit
            decreases b
        {
            if a * a - b * b == n {
                result := true;
                return;
            }
        }
    }
    result := false;
}