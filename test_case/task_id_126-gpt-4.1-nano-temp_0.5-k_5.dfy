method SumOfCommonDivisors(a: int, b: int) returns (sum: int)
  requires a >= 0 && b >= 0
  ensures sum == sumOfCommonDivisors(a, b)
{
    sum := 0;
    var limit := if a < b then a else b;
    var i := 1;
    while i <= limit
        invariant 1 <= i <= limit + 1
        invariant sum == sumOfDivisorsUpTo(i - 1, a, b)
    {
        if a % i == 0 && b % i == 0 {
            sum := sum + i;
        }
        i := i + 1;
    }
}

function sumOfDivisorsUpTo(k: int, a: int, b: int): int
  requires k >= 0
{
    if k < 0 then 0
    else
        sumOfDivisorsUpTo(k - 1, a, b) + (if a % (k + 1) == 0 && b % (k + 1) == 0 then k + 1 else 0)
}