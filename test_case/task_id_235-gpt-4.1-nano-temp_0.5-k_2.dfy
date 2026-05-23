method SetAllEvenBits(n: int) returns (result: int)
    ensures result == n | 0x55555555
{
    result := n | 0x55555555;
}