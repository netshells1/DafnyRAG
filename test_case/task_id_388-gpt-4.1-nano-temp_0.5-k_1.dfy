method HighestPowerOfTwo(n: int) returns (p: int)
    requires n >= 0
    ensures 2^p <= n
    ensures p >= 0
    ensures 2^(p + 1) > n
{
    p := 0;
    var power := 1;
    while power <= n
        invariant 0 <= p <= n
        invariant power == 2^p
        invariant power <= n
        invariant (power * 2) > n
        invariant p == if power <= n then p else p - 1
    {
        power := power * 2;
        p := p + 1;
    }
    // Adjust p back if loop overstepped
    if power > n {
        p := p - 1;
    }
}