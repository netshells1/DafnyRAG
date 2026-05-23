method NNonagonalNumber(n: int) returns (result: int)
    requires n >= 1
    ensures result == (7 * n * (n - 1)) / 2 + n
{
    result := (7 * n * (n - 1)) / 2 + n;
}