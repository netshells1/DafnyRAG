method IsOneLessThanTwiceReverse(n: int) returns (result: bool)
    ensures result <==> n == 2 * reverse(n) - 1
{
    var rev := reverse(n);
    result := n == 2 * rev - 1;
}

function reverse(x: int): int
{
    var s := x.ToString();
    var revStr := s.Reverse();
    var revNum := int.Parse(revStr);
    if x < 0 then
        -revNum
    else
        revNum
}