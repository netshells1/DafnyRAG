method IsOneLessThanTwiceReverse(n: int) returns (result: bool)
    ensures result <==> n == 2 * reverse(n) - 1
{
    var rev := reverse(n);
    result := n == 2 * rev - 1;
}

function reverse(x: int): int
    decreases x
{
    if x < 0 then
        // Handle negative numbers by reversing their absolute value and re-negating
        -reverse(-x)
    else
        reverseHelper(x, 0)
}

function reverseHelper(x: int, acc: int): int
    requires x >= 0
    decreases x
{
    if x == 0 then
        acc
    else
        reverseHelper(x / 10, acc * 10 + x % 10)
}