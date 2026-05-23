predicate IsDigit(c: char)
{
    48 <= c as int <= 57
}

method MoveDigitsToEnd(s: string) returns (result: string)
    ensures result.Length == s.Length
    ensures forall i, j :: 0 <= i < j < result.Length && IsDigit(result[i]) ==> IsDigit(result[j])
    ensures multiset(result[..]) == multiset(s[..])
    ensures forall n, m :: 0 <= n < m < s.Length && !IsDigit(s[n]) && !IsDigit(s[m]) ==> 
            exists k, l :: 0 <= k < l < result.Length && result[k] == s[n] && result[l] == s[m])
{
    var nonDigits := [];
    var digits := [];
    // Collect non-digit characters
    for i := 0 to s.Length - 1
        invariant 0 <= i <= s.Length
        invariant multiset(nonDigits) + multiset(digits) == multiset(s[..0..i])
        invariant forall k :: 0 <= k < i && IsDigit(s[k]) ==> s[k] in digits
        invariant forall k :: 0 <= k < i && !IsDigit(s[k]) ==> s[k] in nonDigits
        // (These invariants help maintain the multisets and order)
    {
        if IsDigit(s[i]) {
            digits := digits + [s[i]];
        } else {
            nonDigits := nonDigits + [s[i]];
        }
    }
    result := nonDigits + digits;
}