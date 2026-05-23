method IsSumOfNonZeroPowersOfTwo(n: int) returns (result: bool)
    requires n >= 0
    ensures result <==> n > 0
{
    result := n > 0;
}