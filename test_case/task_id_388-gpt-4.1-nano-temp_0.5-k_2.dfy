method HighestPowerOfTwoLessThanOrEqual(n: int) returns (p: int)
    requires n >= 0
    ensures p <= n
    ensures p > 0 ==> p * 2 > n
    ensures p == 0 ==> n == 0
{
    p := 1;
    while p * 2 <= n
        invariant 1 <= p
        invariant p * 2 <= n + p
        invariant p == 2 ^ (floor(log2(n)))  // conceptual, for understanding
    {
        p := p * 2;
    }
}