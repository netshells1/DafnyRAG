predicate IsDigit(c: nat)
{
    0 <= c <= 9
}

function FirstDigitOfNumber(n: nat): nat
    requires n > 0
{
    if n < 10 then n
    else FirstDigitOfNumber(n / 10)
}

method FirstDigit(n: nat) returns (d: nat)
    requires n >= 0
    ensures 1 <= d <= n
    ensures d == FirstDigitOfNumber(n)
{
    if n == 0 {
        // For n = 0, define first digit as 0
        d := 0;
    } else {
        d := FirstDigitOfNumber(n);
    }
}