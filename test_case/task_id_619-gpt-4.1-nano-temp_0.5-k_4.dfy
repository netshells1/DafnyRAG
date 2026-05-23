predicate IsDigit(c: char)
{
    48 <= c as int <= 57
}

method MoveNumbersToEnd(s: string) returns (result: string)
    ensures result.Length == s.Length
    ensures forall i, j :: 0 <= i < j < result.Length && exists k, l :: 0 <= k < l < s.Length && IsDigit(s[k]) && IsDigit(s[l]) && result[i] == s[k] && result[j] == s[l] && (forall m :: 0 <= m < i ==> !IsDigit(result[m]))
    ensures multiset(result[..]) == multiset(s[..])
    ensures (forall i :: 0 <= i < result.Length && IsDigit(result[i]) ==> i >= firstNonDigitIndex(result))
{
    var i := 0;
    var j := 0;
    var n := s.Length;
    var resultChars := new char[n];

    // Copy non-digit characters to the front
    while j < n
        invariant 0 <= i <= j <= n
        invariant 0 <= j <= n
        invariant multiset(resultChars[..]) == multiset(s[..])
        invariant forall k :: 0 <= k < i ==> !IsDigit(s[k]) && resultChars[k] == s[k]
        invariant forall k :: i <= k < j ==> resultChars[k] == s[k]
        invariant forall k :: j <= k < n ==> resultChars[k] == s[k]
        invariant forall m :: 0 <= m < i ==> !IsDigit(s[m])
    {
        if !IsDigit(s[j])
        {
            resultChars[i] := s[j];
            i := i + 1;
        }
        j := j + 1;
    }

    // Fill remaining positions with digits
    var digitIndex := i;
    var k := 0;
    while k < n
        invariant 0 <= k <= n
        invariant 0 <= digitIndex <= n
        invariant multiset(resultChars[..]) == multiset(s[..])
        invariant forall m :: 0 <= m < digitIndex ==> IsDigit(s[m]) && resultChars[m] == s[m]
        invariant forall m :: digitIndex <= m < n ==> resultChars[m] == s[m]
    {
        if IsDigit(s[k])
        {
            resultChars[digitIndex] := s[k];
            digitIndex := digitIndex + 1;
        }
        k := k + 1;
    }

    // Convert char array to string
    result := new string(resultChars);
    // The position where digits start
    // To satisfy the postcondition about firstNonDigitIndex, define helper function
}

function firstNonDigitIndex(str: string): int
{
    var i := 0;
    while i < str.Length && IsDigit(str[i])
        invariant 0 <= i <= str.Length
    {
        i := i + 1;
    }
    return i;
}