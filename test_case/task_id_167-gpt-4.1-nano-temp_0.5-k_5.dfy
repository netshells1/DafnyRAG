method NextPowerOfTwo(n: int) returns (power: int)
    requires n >= 0
    ensures power >= n
    ensures power != 0
    ensures (power & (power - 1)) == 0  // power is a power of two
    ensures forall p: int :: p >= n && (p & (p - 1)) == 0 ==> power <= p
{
    power := 1;
    while power < n
        invariant 1 <= power
        invariant power >= n || (power & (power - 1)) == 0
        invariant forall p: int :: p >= n && (p & (p - 1)) == 0 ==> power <= p
    {
        power := power * 2;
    }
}