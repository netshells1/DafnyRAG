method SumOfCommonDivisors(a: int, b: int) returns (sum: int)
    ensures sum == SumCommonDivisors(a, b)
{
    var total := 0;
    var limit := if a > b then a else b; // upper bound for divisors
    // To optimize, we can set limit to min(a, b), since common divisors are at most min(a, b)
    // But for simplicity, using max here
    var maxLimit := if a < b then a else b;
    var i := 1;
    while i <= maxLimit
        invariant 1 <= i <= maxLimit + 1
        invariant total >= 0
        invariant total == sum of all common divisors of a and b less than i
    {
        if a % i == 0 && b % i == 0 {
            total := total + i;
        }
        i := i + 1;
    }
    sum := total;
}

function SumCommonDivisors(x: int, y: int): int
    // Computes the sum of all positive common divisors of x and y
    requires true
    decreases
{
    var s := 0;
    var limit := if x < y then x else y;
    var i := 1;
    while i <= limit
        invariant 1 <= i <= limit + 1
        invariant s >= 0
        invariant s == sum of all k where 1 <= k < i && k divides x && k divides y
    {
        if x % i == 0 && y % i == 0 {
            s := s + i;
        }
        i := i + 1;
    }
    s
}