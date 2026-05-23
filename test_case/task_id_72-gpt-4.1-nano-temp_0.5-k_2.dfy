method CanBeExpressedAsDifferenceOfSquares(n: int) returns (result: bool)
    ensures result <==> exists a, b: int :: n == a * a - b * b
{
    // For any integer n, it can be expressed as a difference of two squares
    // if and only if n is not congruent to 2 modulo 4
    // But to keep it general and verifiable, we check the existence explicitly
    
    var found := false;
    // We set bounds for search to keep verification feasible
    var limit := if n >= 0 then n + 1 else -n + 1;
    result := false;
    // Search for integers a and b such that n == a^2 - b^2
    // We limit the search to a and b within [-limit, limit]
    // To ensure termination and feasibility, we use a bounded search with invariants
    var a := -limit;
    while a <= limit
        invariant -limit <= a <= limit
        invariant result <==> exists a2, b2: int :: -limit <= a2 <= limit && -limit <= b2 <= limit && n == a2 * a2 - b2 * b2
        decreases limit - a
    {
        var b := -limit;
        while b <= limit
            invariant -limit <= b <= limit
            invariant result <==> exists a2, b2: int :: -limit <= a2 <= limit && -limit <= b2 <= limit && n == a2 * a2 - b2 * b2
            decreases limit - b
        {
            if a * a - b * b == n {
                result := true;
                return;
            }
            b := b + 1;
        }
        a := a + 1;
    }
    result := false;
}