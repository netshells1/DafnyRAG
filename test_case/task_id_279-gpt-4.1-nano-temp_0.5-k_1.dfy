method DecagonalNumber(n: int) returns (d: int)
  requires n >= 0
  ensures d == 4 * n * (n - 1) + 1
{
    d := 4 * n * (n - 1) + 1;
}