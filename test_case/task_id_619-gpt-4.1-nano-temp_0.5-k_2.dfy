predicate IsDigit(c: char)
{
    48 <= c as int <= 57
}

method MoveNumbersToEnd(s: string) returns (result: string)
    ensures result.Length == s.Length
    ensures multiset([c | c in result]) == multiset([c | c in s])
    ensures forall i, j :: 0 <= i < j < result.Length && IsDigit(result[i]) ==> IsDigit(result[j])
    ensures forall i, j :: 0 <= i < j < result.Length && !IsDigit(result[i]) ==> !IsDigit(result[j])
    ensures forall n, m :: 0 <= n < m < s.Length && !IsDigit(s[n]) && !IsDigit(s[m]) ==> 
            result[?k] == s[n] && result[?l] == s[m] && k < l
{
    var nonDigits := "";
    var digits := "";

    var i := 0;
    while i < s.Length
        invariant 0 <= i <= s.Length
        invariant multiset([c | c in s[..i]]) == multiset([c | c in nonDigits + digits])
        invariant forall k :: 0 <= k < i && IsDigit(s[k]) ==> s[k] in digits
        invariant forall k :: 0 <= k < i && !IsDigit(s[k]) ==> s[k] in nonDigits
        invariant multiset([c | c in nonDigits]) + multiset([c | c in digits]) == multiset([c | c in s[..i]])
        {
        if IsDigit(s[i])
        {
            digits := digits + [s[i]];
        }
        else
        {
            nonDigits := nonDigits + [s[i]];
        }
        i := i + 1;
    }

    result := nonDigits + digits;
}