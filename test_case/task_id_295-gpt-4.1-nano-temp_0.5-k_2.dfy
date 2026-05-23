method SumOfDivisors(n: int) returns (sum: int)
    requires n >= 0
    ensures sum == (if n == 0 then 0 else
                        // sum over all divisors d of n
                        SumDivisors(n))
{
    sum := 0;
    var d := 1;
    while d <= n
        invariant 1 <= d <= n + 1
        invariant sum == SumDivisorsUpTo(n, d - 1)
    {
        if n % d == 0 {
            sum := sum + d;
        }
        d := d + 1;
    }
}

// Helper function: sum of divisors of n up to d
function SumDivisorsUpTo(n: int, d: int): int
    requires n >= 0
    requires 0 <= d <= n
{
    if d == 0 then 0
    else if n % d == 0 then d + SumDivisorsUpTo(n, d - 1)
    else SumDivisorsUpTo(n, d - 1)
}

// Helper function: sum of all divisors of n
function SumDivisors(n: int): int
    requires n >= 0
{
    SumDivisorsUpTo(n, n)
}