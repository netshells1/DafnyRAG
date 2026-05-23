method SumOfCommonDivisors(a: int, b: int) returns (sum: int)
  requires a >= 0 && b >= 0
  ensures sum == sum(i | 1 <= i <= if a < b then a else b && a % i == 0 && b % i == 0)
{
    var limit := if a < b then a else b;
    sum := 0;
    var i := 1;
    while i <= limit
      invariant 0 <= i <= limit + 1
      invariant sum == sum(k | 1 <= k < i && a % k == 0 && b % k == 0)
    {
      if a % i == 0 && b % i == 0 {
        sum := sum + i;
      }
      i := i + 1;
    }
}