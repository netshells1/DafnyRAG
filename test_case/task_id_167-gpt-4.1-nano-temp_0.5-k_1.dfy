method NextPowerOfTwo(n: int) returns (result: int)
    requires n >= 0
    ensures result >= n
    ensures result > 0
    ensures exists k: int :: result == 1 << k
    ensures result / 2 < n or n == 0
{
    if n == 0 {
        result := 1;
    } else {
        result := 1;
        while result < n
            invariant result >= 1
            invariant result >= n or result == 1
            invariant exists k: int :: result == 1 << k
        {
            result := result << 1;
        }
    }
}