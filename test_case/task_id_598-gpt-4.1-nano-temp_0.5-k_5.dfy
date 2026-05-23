method IsArmstrong(n: int) returns (result: bool)
    requires n >= 0
    ensures result <==> (exists s: int :: s >= 0 && s == numberOfDigits(n) && n == sumOfDigitsPowered(n, s))
{
    var s := numberOfDigits(n);
    var sum := 0;
    var temp := n;
    while temp > 0
        invariant temp >= 0
        invariant sum == sumOfDigitsPowered(n, s) - (if temp == 0 then 0 else 0) // placeholder for potential invariants
        // To prove correctness, we need to maintain the sum of digits raised to power s
    {
        var digit := temp % 10;
        sum := sum + power(digit, s);
        temp := temp / 10;
    }
    result := (n == sum);
}

// Helper function to compute number of digits
function method numberOfDigits(x: int): int
{
    if x == 0 then 1 else 1 + numberOfDigits(x / 10)
}

// Helper function to compute power
function method power(base: int, exp: int): int
{
    if exp == 0 then 1 else base * power(base, exp - 1)
}