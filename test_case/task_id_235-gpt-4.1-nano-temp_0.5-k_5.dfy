method SetEvenBits(n: int) returns (result: int)
    ensures (result & 0x55555555) == (n & 0x55555555) // odd bits unchanged
    ensures (result | 0x55555555) == result // all even bits are set to 1
{
    // Set all even bits to 1 by OR-ing with the mask
    result := n | 0x55555555;
}