predicate FirstDigitOfNumber(n: int, d: int)
{
    0 <= d <= 9 &&
    n >= Power10(NumberOfDigits(n) - 1) &&
    n < Power10(NumberOfDigits(n))
}

method FirstDigit(n: int) returns (d: int)
    requires n >= 0
    ensures 0 <= d <= 9
    ensures FirstDigitOfNumber(n, d)
{
    var temp := n;
    // Reduce n until it is less than 10
    while temp >= 10
        invariant 0 <= temp
        invariant temp >= Power10(NumberOfDigits(temp) - 1)
        invariant temp < Power10(NumberOfDigits(temp))
        invariant 1 <= NumberOfDigits(temp)
        invariant temp == n / Power10(NumberOfDigits(n) - NumberOfDigits(temp))
    {
        temp := temp / 10;
    }
    d := temp;
}