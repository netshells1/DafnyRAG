function method ConcatenateNumbers(a: array<int>): int
  requires a != null
  decreases a.Length
{
  var res := 0;
  var i := 0;
  while i < a.Length
    invariant 0 <= i <= a.Length
    invariant res == ConcatenateNumbersPrefix(a, i)
  {
    res := res * PowerOfTen(LengthOfNumber(a[i])) + a[i];
    i := i + 1;
  }
  res
}

function method PowerOfTen(n: int): int
  requires n >= 0
  decreases n
{
  if n == 0 then 1 else 10 * PowerOfTen(n - 1)
}

function method LengthOfNumber(n: int): int
  requires n >= 0
  decreases n
{
  if n < 10 then 1 else 1 + LengthOfNumber(n / 10)
}

function method ConcatenateNumbersPrefix(a: array<int>, i: int): int
  requires 0 <= i <= a.Length
  decreases i
{
  if i == 0 then 0
  else ConcatenateNumbersPrefix(a, i - 1) * PowerOfTen(LengthOfNumber(a[i - 1])) + a[i - 1]
}

method JoinArray(a: array<int>) returns (result: int)
  requires a != null
  ensures result == ConcatenateNumbers(a)
{
  var result := 0;
  var i := 0;
  while i < a.Length
    invariant 0 <= i <= a.Length
    invariant result == ConcatenateNumbersPrefix(a, i)
  {
    result := result * PowerOfTen(LengthOfNumber(a[i])) + a[i];
    i := i + 1;
  }
}