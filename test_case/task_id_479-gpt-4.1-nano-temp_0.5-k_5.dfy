predicate FirstDigitOf(n: int, d: int)
{
    0 <= d < 10 && n >= 0 &&
    (n < 10 ==> d == n) &&
    (n >= 10 ==> exists m: int :: n == m * 10 + d && m >= 1)
}

method FirstDigit(n: int) returns (d: int)
    requires n >= 0
    ensures 0 <= d < 10
    ensures FirstDigitOf(n, d)
{
    var temp := n;
    // Repeatedly divide n by 10 until it's less than 10
    while temp >= 10
        invariant temp >= 1
        invariant temp >= 10 ==> exists m: int :: temp == m * 10
        decreases temp
    {
        temp := temp / 10;
    }
    d := temp;
}