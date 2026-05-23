method ClosestSmaller(n: int) returns (result: int)
    requires n >= 0
    ensures result < n
    ensures result >= 0
{
    if n == 0 {
        result := 0; // or handle as per requirement, but since 0 has no smaller natural number, possibly define result := 0
    } else {
        result := n - 1;
    }
}