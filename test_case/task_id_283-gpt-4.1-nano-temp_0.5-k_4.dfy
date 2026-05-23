method CheckDigitFrequencies(n: int) returns (result: bool)
  ensures result <==> (forall d :: 0 <= d <= 9 ==> CountDigitInNumber(n, d) <= d)
{
    result := true;
    var digitCounts := new int[10];
    var temp := n;
    if temp < 0 then
        temp := -temp; // handle negative numbers
    while temp != 0
        invariant 0 <= temp
        invariant forall k :: 0 <= k < 10 ==> 0 <= digitCounts[k]
        decreases temp
    {
        var digit := temp % 10;
        digitCounts[digit] := digitCounts[digit] + 1;
        temp := temp / 10;
    }
    // handle case when n == 0
    if n == 0 {
        digitCounts[0] := 1;
    }
    // Check the frequency condition for each digit
    var d := 0;
    while d <= 9
        invariant 0 <= d <= 10
        invariant result ==> (forall k :: 0 <= k < d ==> CountDigitInNumber(n, k) <= k)
        decreases 10 - d
    {
        if digitCounts[d] > d {
            result := false;
            break;
        }
        d := d + 1;
    }
}

function CountDigitInNumber(n: int, digit: int): int
  ensures result >= 0
{
    var count := 0;
    var temp := n;
    if temp < 0 then
        temp := -temp; // handle negative numbers
    while temp != 0
        invariant 0 <= temp
        invariant count >= 0
        decreases temp
    {
        if temp % 10 == digit {
            count := count + 1;
        }
        temp := temp / 10;
    }
    if n == 0 && digit == 0 {
        count := 1;
    }
    result := count;
}