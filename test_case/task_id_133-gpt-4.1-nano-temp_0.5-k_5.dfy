method SumNegativeNumbers(lst: seq<int>) returns (sum: int)
    ensures sum == SumNegatives(lst)
{
    sum := 0;
    var i := 0;
    while i < |lst|
        invariant 0 <= i <= |lst|
        invariant sum == SumNegatives(lst[..i])
    {
        if lst[i] < 0 {
            sum := sum + lst[i];
        }
        i := i + 1;
    }
}

function SumNegatives(s: seq<int>) : int
    decreases s
{
    if |s| == 0 then 0
    else
        var head := s[0];
        var tail := s[1..];
        if head < 0 then head + SumNegatives(tail)
        else SumNegatives(tail)
    }
}