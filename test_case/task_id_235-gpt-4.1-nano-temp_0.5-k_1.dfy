method SetAllEvenBits(n: int) returns (result: int)
    ensures (forall i: int :: 0 <= i < 32 ==> (i % 2 == 0 ==> ((result >> i) & 1) == 1))
    ensures (forall i: int :: 0 <= i < 32 ==> (i % 2 == 1 ==> ((result >> i) & 1) == ((n >> i) & 1)))
{
    // Create a mask with all even bits set to 1: bits 0,2,4,...,30
    var mask: int := 0;
    var i := 0;
    while i < 32
        invariant 0 <= i <= 32
        invariant mask == ( (1 << i) - 1 ) & (.. bits with even positions set)
        // To generate mask with even bits set:
        // For each even i, set bit i
        // We'll set bits at even positions
    {
        if i % 2 == 0 {
            mask := mask | (1 << i);
        }
        i := i + 1;
    }
    result := n | mask;
}