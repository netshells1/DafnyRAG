predicate IsDigit(c: char)
{
    48 <= c as int <= 57
}

function sumDigits(sub: seq<char>): int
{
    if |sub| == 0 then 0
    else (sub[0] as int - 48) + sumDigits(sub[1..])
}

method CountSubstringsWithSumEqualLength(s: string) returns (count: int)
    requires s != null
    ensures count >= 0
    ensures count == |{ sub: seq<char> | exists i, j :: 0 <= i <= j < |s| && sumDigits(s[i..j]) == (j - i + 1)}|
{
    count := 0;
    var n := |s|;
    var chars := s[..];

    // Iterate over all possible substrings
    for i := 0 to n - 1
        invariant 0 <= i <= n
        // For each starting index, iterate over ending index
        for j := i to n - 1
            invariant i <= j + 1 <= n
            // Compute sum of digits in s[i..j]
            ghost var sum_sub := 0;
            ghost var k := i;
            while k <= j
                invariant i <= k <= j + 1
                invariant sum_sub == sumDigits(s[i..k])
                decreases j - k
            {
                sum_sub := sum_sub + (s[k] as int - 48);
                k := k + 1;
            }
            // Check if sum of digits equals length
            if sum_sub == (j - i + 1) {
                count := count + 1;
            }
        }
}