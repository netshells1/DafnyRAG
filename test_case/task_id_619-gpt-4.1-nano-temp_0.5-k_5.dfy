predicate IsDigit(c: char)
{
    48 <= c as int <= 57
}

method MoveNumbersToEnd(s: string) returns (result: string)
    requires s != null
    ensures result.Length == s.Length
    ensures forall i, j :: 0 <= i < j < result.Length && IsDigit(result[i]) ==> IsDigit(result[j])
    ensures multiset(result[..]) == multiset(s[..])
    ensures forall n, m :: 0 <= n < m < s.Length && !IsDigit(s[n]) && !IsDigit(s[m]) ==> 
            exists k, l :: 0 <= k < l < result.Length && result[k] == s[n] && result[l] == s[m]
{
    var nonDigits := "";
    var digits := "";

    // Collect non-digit characters and digits separately
    var i := 0;
    while i < s.Length
        invariant 0 <= i <= s.Length
        invariant multiset(s[..]) == multiset(nonDigits + digits)
        invariant multiset(nonDigits[..]) + multiset(digits[..]) == multiset(s[..])
        invariant forall k :: 0 <= k < i ==> s[k] in nonDigits || s[k] in digits
        invariant forall k :: 0 <= k < i && s[k] in nonDigits ==> s[k] in nonDigits
        invariant forall k :: 0 <= k < i && s[k] in digits ==> s[k] in digits
    {
        if IsDigit(s[i]) {
            digits := digits + [s[i]];
        } else {
            nonDigits := nonDigits + [s[i]];
        }
        i := i + 1;
    }
    result := nonDigits + digits;
}