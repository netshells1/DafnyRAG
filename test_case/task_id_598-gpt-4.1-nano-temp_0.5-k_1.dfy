method IsArmstrong(n: int) returns (result: bool)
  requires n >= 0
  ensures result == (n == SumOfDigitsPowered(n))
{
  var digitCount := CountDigits(n);
  var sum := 0;
  var temp := n;
  while temp > 0
    invariant 0 <= temp <= n
    invariant sum <= n
    invariant sum == SumOfDigitsPowered(n - temp + temp % 10 * Pow(digitCount, 1))
  {
    var d := temp % 10;
    sum := sum + Pow(d, digitCount);
    temp := temp / 10;
  }
  if n == 0 {
    sum := 0; // handle the case when n=0
  }
  result := (n == sum);
}

function CountDigits(x: int): int
  ensures CountDigits(x) > 0
{
  if x == 0 then 1 else 1 + CountDigits(x / 10)
}

function Pow(base: int, exp: int): int
  ensures Pow(base, exp) >= 0
{
  if exp == 0 then 1
  else base * Pow(base, exp - 1)
}

function SumOfDigitsPowered(x: int): int
  ensures SumOfDigitsPowered(x) >= 0
{
  if x == 0 then 0
  else
    let d := x % 10;
    d ^ CountDigits(x) + SumOfDigitsPowered(x / 10)
}