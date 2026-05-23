method SetAllEvenBits(n: int) returns (result: int)
    ensures (result & 0x55555555) == 0x55555555
{
    // Set all even bits to 1
    result := n | 0x55555555;
}