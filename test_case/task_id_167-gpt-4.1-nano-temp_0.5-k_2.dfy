method NextPowerOfTwo(n: int) returns (result: int)
    requires n >= 0
    ensures result >= n
    ensures exists k :: result == 2^k
    ensures result / 2 < n || n == 0
{
    var power := 1;
    // For n=0, the smallest power of two >= 0 is 1
    if n == 0 {
        return 1;
    }
    // Loop to find the smallest power of two >= n
    while power < n
        invariant power >= 1
        invariant power >= n || power == 1
        invariant exists k :: power == 2^k
    {
        power := power * 2;
    }
    result := power;
}