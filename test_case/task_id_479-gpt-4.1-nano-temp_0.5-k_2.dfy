predicate FirstDigitOfNumber(n: int, d: int)
{
    n >= 0 && 0 <= d < 10 && (n < 10 ==> d == n) && (n >= 10 ==> exists m: int :: n == m * 10 + d && m >= 1)
}

method FirstDigit(n: int) returns (d: int)
    requires n >= 0
    ensures 0 <= d < 10
    ensures FirstDigitOfNumber(n, d)
{
    var temp := n;
    // Keep dividing by 10 until n is less than 10
    while temp >= 10
        invariant temp >= 1
        invariant 0 <= d <= 9
        invariant FirstDigitOfNumber(n, d)
    {
        temp := temp / 10;
    }
    d := temp;
}