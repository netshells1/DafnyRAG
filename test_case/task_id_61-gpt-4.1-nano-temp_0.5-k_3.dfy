predicate IsDigit(c: char)
{
    48 <= c as int <= 57
}

method CountSubstringsSumDigitsEqualsLength(s: string) returns (count: int)
    requires s != null
    ensures count >= 0
    ensures count == |{ start, end :: 0 <= start <= end < |s| &&
        let sub := s[start..end+1] in
        |sub| == SumDigitsInSubstring(sub) }|
{
    count := 0;
    var n := |s|;
    // Iterate over all substrings
    for start := 0 to n - 1
        invariant 0 <= start <= n
        decreases n - start
    {
        for end := start to n - 1
            invariant start <= end + 1 <= n
            // Substring from start to end
            var sub := s[start..end+1];
            // Compute sum of digits in sub
            var sumDigits := 0;
            // Loop over characters in sub
            var i := 0;
            while i < |sub|
                invariant 0 <= i <= |sub|
                invariant sumDigits == SumDigitsInSubstring(sub[..i])
                decreases |sub| - i
            {
                if IsDigit(sub[i]) {
                    sumDigits := sumDigits + (sub[i] as int) - 48;
                }
                i := i + 1;
            }
            if sumDigits == |sub| {
                count := count + 1;
            }
        }
    }
}

// Helper function to compute sum of digits in a string
function SumDigitsInSubstring(sub: seq<char>): int
{
    if |sub| == 0 then 0
    else
        var head := sub[0];
        var tail := sub[1..];
        if IsDigit(head) then
            (head as int) - 48 + SumDigitsInSubstring(tail)
        else
            SumDigitsInSubstring(tail)
}

// Note: The above code relies on the fact that only digit characters contribute to the sum.
// The postcondition ensures the count matches the total number of substrings where the sum of digits equals the substring length.