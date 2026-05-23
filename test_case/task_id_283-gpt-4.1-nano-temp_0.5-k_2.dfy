method CheckDigitFrequencies(n: int) returns (result: bool)
    ensures result <==> (forall d: int :: 0 <= d <= 9 ==> CountDigitInNumber(n, d) <= d)
{
    var counts := new int[10];
    var temp := n;
    if temp < 0 then
        temp := -temp; // consider absolute value for digit counting
    var i := 0;
    while temp > 0
        invariant 0 <= i <= |counts|
        invariant forall j: int :: 0 <= j < 10 ==> counts[j] >= 0
        invariant temp >= 0
        invariant counts[..] == old(counts[..])
        // counts will be updated
    {
        var digit := temp % 10;
        counts[digit] := counts[digit] + 1;
        temp := temp / 10;
        i := i + 1;
    }
    // handle case when n == 0
    if n == 0 {
        counts[0] := counts[0] + 1;
    }

    result := true;
    var d := 0;
    while d <= 9
        invariant 0 <= d <= 10
        invariant result <==> (forall k: int :: 0 <= k <= d-1 ==> (Counts[k] <= k))
    {
        if d <= 9 {
            if counts[d] > d {
                result := false;
            }
            d := d + 1;
        } else {
            break;
        }
    }
}

function CountDigitInNumber(n: int, d: int): nat
    requires 0 <= d <= 9
{
    var count := 0;
    var temp := n;
    if temp < 0 then
        temp := -temp;
    while temp > 0
        invariant 0 <= count <= |NumberToSeq(temp)|
        invariant temp >= 0
        invariant count == CountDigitInNumberSeq(NumberToSeq(temp), d)
    {
        if temp % 10 == d {
            count := count + 1;
        }
        temp := temp / 10;
    }
    if n == 0 && d == 0 {
        count := 1;
    }
    count
}

function CountDigitInNumberSeq(digits: seq<int>, d: int): nat
{
    if |digits| == 0 then 0
    else (if digits[0] == d then 1 else 0) + CountDigitInNumberSeq(digits[1..], d)
}

function NumberToSeq(n: int): seq<int>
{
    if n == 0 then []
    else [n % 10] + NumberToSeq(n / 10)
}