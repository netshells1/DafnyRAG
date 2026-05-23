method HighestPowerOfTwoLessThanOrEqual(n: int) returns (p: int)
    requires n >= 0
    ensures p >= 0
    ensures 2^p <= n
    ensures p == 0 || 2^(p+1) > n
{
    p := 0;
    var power := 1;
    // Loop to find the highest power of two less than or equal to n
    while power <= n
        invariant p >= 0
        invariant power == 2^p
        invariant power <= n
        invariant p == |power|
        // Since power doubles each iteration, p increases by 1 each time
        decreases n - power
    {
        power := power * 2;
        p := p + 1;
    }
}