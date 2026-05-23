method SumOfDivisors(n: nat) returns (sum: nat)
    requires n >= 0
    ensures sum == SumDivisors(n)
{
    sum := 0;
    var i := 1;
    while i <= n
        invariant 1 <= i <= n + 1
        invariant sum == SumDivisorsUpTo(n, i - 1)
    {
        if n % i == 0 {
            sum := sum + i;
        }
        i := i + 1;
    }
}

function SumDivisors(n: nat): nat
    ensures result >= 0
{
    // Sum of all positive divisors of n
    // This function can be defined recursively or as a sum over a range
    // For simplicity, define as a sum over 1..n
    var total := 0;
    var i := 1;
    while i <= n
        invariant 1 <= i <= n + 1
        invariant total == SumDivisorsUpTo(n, i - 1)
    {
        if n % i == 0 {
            total := total + i;
        }
        i := i + 1;
    }
    total
}

function SumDivisorsUpTo(n: nat, limit: nat): nat
    requires 0 <= limit <= n
{
    if limit == 0 then 0
    else (if n % limit == 0 then limit else 0) + SumDivisorsUpTo(n, limit - 1)
}