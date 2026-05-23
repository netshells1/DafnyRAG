method NextPowerOfTwo(n: int) returns (result: int)
    requires n >= 0
    ensures result >= n
    ensures result != 0
    ensures exists k: int :: result == 1 << k
    ensures result / 2 < n || result == n
{
    var power := 1;
    while power < n
        invariant power >= 1
        invariant power >= n or power == n
        invariant exists k: int :: power == 1 << k
    {
        power := power * 2;
    }
    result := power;
}