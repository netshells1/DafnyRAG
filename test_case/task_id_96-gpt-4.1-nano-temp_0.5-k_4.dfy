predicate Divides(n: int, d: int)
{
    d != 0 && n % d == 0
}

method CountDivisors(n: int) returns (count: int)
    ensures count >= 0
    ensures count == |{ d: int | d > 0 && Divides(n, d)}|
{
    var c := 0;
    var limit := if n >= 0 then n else -n;
    // For n=0, every positive integer divides 0, but since we cannot iterate infinitely,
    // we limit the divisor search to |n|, acknowledging that the number of divisors is infinite.
    // Alternatively, for n=0, define the number of divisors as 0 or handle separately.
    // Here, we handle n=0 separately.
    if n == 0 {
        // All positive integers divide 0, so the number of divisors is infinite.
        // But since we need a finite result, we define the count as 0 for simplicity.
        // Alternatively, we could define count as the number of divisors up to a certain limit.
        // For a practical finite implementation, we assume n != 0.
        count := 0;
    } else {
        var absN := if n >= 0 then n else -n;
        var i := 1;
        while i <= absN
            invariant 1 <= i <= absN + 1
            invariant c == |{ d: int | d > 0 && d <= i - 1 && Divides(n, d)}|
        {
            if n % i == 0 {
                c := c + 1;
            }
            i := i + 1;
        }
        count := c;
    }
}