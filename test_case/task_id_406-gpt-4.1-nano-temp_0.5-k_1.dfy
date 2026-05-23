method IsParityOdd(n: int) returns (result: bool)
    ensures result <==> n % 2 == 1
{
    result := n % 2 == 1;
}