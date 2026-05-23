method IsOneLessThanTwiceReverse(n: int) returns (result: bool)
    ensures result <==> n == 2 * Reverse(n) - 1
{
    var rev := Reverse(n);
    result := n == 2 * rev - 1;
}

function Reverse(x: int): int
{
    var r := 0;
    var temp := x;
    while temp != 0
        invariant true
        decreases temp
    {
        r := r * 10 + temp % 10;
        temp := temp / 10;
    }
    r
}