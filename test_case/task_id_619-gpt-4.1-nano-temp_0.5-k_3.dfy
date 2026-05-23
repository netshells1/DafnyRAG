predicate IsDigit(c: char)
{
    48 <= c as int <= 57
}

method MoveNumbersToEnd(s: string)
    requires s != null
    modifies s
    ensures s.Length == old(s.Length)
    ensures forall i, j :: 0 <= i < j < s.Length && IsDigit(s[i]) ==> j >= firstNonDigitIndex
    ensures forall i, j :: 0 <= i < j < s.Length && !IsDigit(s[i]) ==> s[i] == old(s[i]) || (i < firstNonDigitIndex && s[i] == old(s[i]))
    ensures multiset(s[..]) == multiset(old(s[..]))
{
    var nonDigitChars := "";
    var digitCount := 0;
    var index := 0;
    var length := s.Length;

    // Count digits and collect non-digit characters
    var i := 0;
    while i < length
        invariant 0 <= i <= length
        invariant multiset(nonDigitChars) + multiset(s[i..]) == multiset(s[..])
        invariant digitCount + (length - i) == length
    {
        if IsDigit(s[i]) {
            digitCount := digitCount + 1;
        } else {
            nonDigitChars := nonDigitChars + [s[i]];
        }
        i := i + 1;
    }

    // Reconstruct the string: non-digit characters followed by digits
    var result := nonDigitChars + s[length - digitCount ..];

    // Assign back to s
    s := result;
}