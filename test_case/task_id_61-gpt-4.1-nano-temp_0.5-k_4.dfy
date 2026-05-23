predicate IsDigit(c: char)
{
    48 <= c as int <= 57
}

method CountSubstringsWithSumEqualLength(s: string) returns (count: int)
    requires s != null
    ensures count >= 0
    ensures count == | { (i, j) | 0 <= i <= j < |s| && SumDigits(s[i..j]) == (j - i + 1) } |
{
    count := 0;
    var n := |s|;
    for start := 0 to n - 1
        invariant 0 <= start <= n
        invariant count >= 0
    {
        for end := start to n - 1
            invariant start <= end < n + 1
            invariant count >= 0
        {
            var substring := s[start..end+1];
            if SumDigits(substring) == (end - start + 1) {
                count := count + 1;
            }
        }
    }
}

function SumDigits(sub: string): int
{
    if |sub| == 0 then 0
    else
        var c := sub[0];
        if IsDigit(c) then
            (c as int) - 48 + SumDigits(sub[1..])
        else
            SumDigits(sub[1..])
}