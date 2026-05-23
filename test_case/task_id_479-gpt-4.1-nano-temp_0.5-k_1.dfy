predicate FirstDigitOf(n: int, d: int)
{
    0 <= d < 10 && n >= Power10(NumberOfDigits(n)-1) && n < Power10(NumberOfDigits(n))
}

method FirstDigit(n: int) returns (d: int)
    requires n >= 0
    ensures 0 <= d < 10
    ensures FirstDigitOf(n, d)
{
    var temp := n;
    // Reduce n until it is less than the next power of ten
    while temp >= 10
        invariant 10 <= temp < n + 1
        invariant n >= Power10(NumberOfDigits(n)-1)
        invariant n < Power10(NumberOfDigits(n))
        invariant temp >= Power10(NumberOfDigits(temp)-1)
        invariant temp < Power10(NumberOfDigits(temp))
    {
        temp := temp / 10;
    }
    d := temp;
}