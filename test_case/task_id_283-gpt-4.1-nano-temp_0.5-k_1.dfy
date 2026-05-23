method CheckDigitFrequencies(n: int) returns (result: bool)
  ensures result <==> (forall d :: 0 <= d <= 9 ==> CountDigit(n, d) <= d)
{
    result := true;
    var count := new int[10];
    var temp := n;
    // Count occurrences of each digit
    while temp != 0
        invariant 0 <= temp
        invariant forall d :: 0 <= d <= 9 ==> 0 <= count[d]
        invariant var t := temp; t >= 0 && (t == 0 || true)
        decreases temp
    {
        var digit := temp % 10;
        count[digit] := count[digit] + 1;
        temp := temp / 10;
    }
    // Check the condition for each digit
    var d := 0;
    while d <= 9
        invariant 0 <= d <= 10
        invariant result <==> (forall dd :: 0 <= dd < d ==> CountDigit(n, dd) <= dd)
        decreases 10 - d
    {
        if count[d] > d {
            result := false;
            break;
        }
        d := d + 1;
    }
}

function CountDigit(n: int, d: int): int
  ensures result >= 0
{
    if n == 0 && d == 0 then
        1
    else if n == 0 then
        0
    else
        var count := 0;
        var temp := n;
        while temp != 0
            invariant 0 <= temp
            invariant count >= 0
            decreases temp
        {
            if temp % 10 == d {
                count := count + 1;
            }
            temp := temp / 10;
        }
        count
}