predicate IsDigit(c: char)
{
    48 <= c as int <= 57
}

function sumDigits(sub: string): int
{
    if |sub| == 0 then 0 else (sub[0] as int - 48) + sumDigits(sub[1..])
}

method CountSubstringsWithSumEqualLength(s: string) returns (count: int)
    requires s != null
    ensures count >= 0
    ensures count == |{ sub: string | sub in Substrings(s) && sumDigits(sub) == |sub| }|
{
    count := 0;
    var n := |s|;
    for start := 0 to n - 1
        invariant 0 <= start <= n
        for end := start + 1 to n
            invariant start <= end <= n
            var sub := s[start..end];
            if sumDigits(sub) == |sub| {
                count := count + 1;
            }
        }
    }
}