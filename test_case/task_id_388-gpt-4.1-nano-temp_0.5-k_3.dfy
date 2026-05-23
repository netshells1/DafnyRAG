method HighestPowerOfTwoLessThanOrEqual(n: int) returns (p: int)
    requires n >= 0
    ensures p == 0 && n == 0
    ensures p > 0 ==> p <= n
    ensures p > 0 ==> exists k: int :: p == 2 ^ k
    ensures p <= n
{
    if n == 0 {
        p := 0;
        return;
    }
    var power := 1;
    var prev := 0;
    while power <= n
        invariant 1 <= power <= n + 1
        invariant prev <= n
        invariant exists k: int :: prev == 2 ^ k
        invariant power > prev
        decreases n - power
    {
        prev := power;
        power := power * 2;
    }
    p := prev;
}