method LastDigitFactorial(n: int) returns (fact: int)
  requires n >= 0
  ensures fact == factorial(n % 10)
{
    var d := n % 10;
    fact := 1;
    var i := 1;
    while i <= d
        invariant 1 <= i <= d + 1
        invariant fact == factorial(i - 1)
    {
        fact := fact * i;
        i := i + 1;
    }
}

/// Helper function to define factorial
function factorial(k: int): int
  requires k >= 0
  decreases k
{
    if k == 0 then 1 else k * factorial(k - 1)
}