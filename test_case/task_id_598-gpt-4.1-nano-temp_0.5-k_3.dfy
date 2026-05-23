method IsArmstrong(n: int) returns (result: bool)
    requires n >= 0
    ensures result <==> (n == SumOfDigitsPowered(n))
{
    var numDigits := NumDigits(n);
    var sum := 0;
    var temp := n;
    while temp > 0
        invariant 0 <= temp <= n
        invariant sum == SumDigitsPower(temp, numDigits)
    {
        var digit := temp % 10;
        sum := sum + Power(digit, numDigits);
        temp := temp / 10;
    }
    // Handle the case when n == 0
    if n == 0 {
        result := true;
    } else {
        result := n == sum;
    }
}

// Helper function to compute number of digits
function NumDigits(x: int): int
    requires x >= 0
{
    if x == 0 then 1 else 1 + NumDigits(x / 10)
}

// Helper function to compute sum of digits powered
function SumDigitsPower(x: int, power: int): int
    requires x >= 0
{
    if x == 0 then 0
    else (x % 10) ^ power + SumDigitsPower(x / 10, power)
}

// Helper function for exponentiation
function Power(base: int, exp: int): int
    requires exp >= 0
{
    if exp == 0 then 1 else base * Power(base, exp - 1)
}