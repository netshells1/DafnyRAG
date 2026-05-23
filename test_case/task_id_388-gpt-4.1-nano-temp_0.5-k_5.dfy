method HighestPowerOfTwoLessThanOrEqual(n: int) returns (p: int)
  requires n >= 0
  ensures p > 0 ==> p <= n
  ensures p == 0 ==> n < 1
  ensures 2 * p > n
  ensures (p == 0) || (p / 2 < n)
{
    p := 1;
    while 2 * p <= n
        invariant p > 0
        invariant p <= n
        invariant 2 * p <= n
        invariant (2 * p) <= n
    {
        p := p * 2;
    }
    if n < 1 {
        p := 0;
    }
}