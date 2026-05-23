method IsArmstrong(n: int) returns (result: bool)
    requires n >= 0
    ensures result <==> (exists k: int :: 10 ^ (kDigits(n) - 1) <= n < 10 ^ kDigits(n) && n == SumDigitsPower(n))
{
    var k := kDigits(n);
    var sum := 0;
    var temp := n;
    while temp > 0
        invariant 0 <= temp <= n
        invariant sum == SumDigitsPowerPrefix(n, k)
        invariant k == kDigits(n)
    {
        var d := temp % 10;
        sum := sum + d ^ k;
        temp := temp / 10;
    }
    result := (n == sum);
}

// Helper functions
function kDigits(x: int): int
    reads {}
{
    if x < 10 then 1 else 1 + kDigits(x / 10)
}

function SumDigitsPower(x: int): int
    reads {}
{
    if x == 0 then 0
    else let d := x % 10 in
         d ^ kDigits(x) + SumDigitsPower(x / 10)
}

function SumDigitsPowerPrefix(x: int, k: int): int
    reads {}
{
    if x == 0 then 0
    else let d := x % 10 in
         d ^ k + SumDigitsPowerPrefix(x / 10, k)
}