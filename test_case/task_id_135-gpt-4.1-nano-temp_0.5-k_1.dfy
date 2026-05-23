method HexagonalNumber(n: int) returns (h: int)
  requires n >= 0
  ensures h == n * (2 * n - 1)
{
    h := n * (2 * n - 1);
}