method IsOneLessThanTwiceReverse(n: int) returns (result: bool)
  ensures result <==> n == 2 * Reverse(n) - 1
{
    var rev := Reverse(n);
    result := n == 2 * rev - 1;
}

method Reverse(x: int) returns (rev: int)
  ensures rev >= 0
  ensures (x >= 0 ==> rev >= 0)
{
    rev := 0;
    var temp := x;
    while temp > 0
        invariant rev >= 0
        invariant temp >= 0
        invariant rev == (if x >= 0 then ReverseHelper(temp) else 0)
    {
        rev := rev * 10 + temp % 10;
        temp := temp / 10;
    }
}

function ReverseHelper(num: int): int
  ensures ReverseHelper(num) >= 0
{
    if num == 0 then 0 else (num % 10) + 10 * ReverseHelper(num / 10)
}