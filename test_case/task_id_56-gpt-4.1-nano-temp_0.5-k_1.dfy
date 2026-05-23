method IsOneLessThanTwiceReverse(n: int) returns (result: bool)
    ensures result <==> n == 2 * Reverse(n) - 1
{
    var rev := Reverse(n);
    result := n == 2 * rev - 1;
}

function method Reverse(x: int): int
    decreases x
{
    if x < 10 then x
    else {
        var lastDigit := x % 10;
        var rest := x / 10;
        return lastDigit + 10 * Reverse(rest);
    }
}