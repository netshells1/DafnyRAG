predicate IsWhitespace(c: char)
{
    c == ' ' || c == '\t' || c == '\n' || c == '\r' || c == '\v' || c == '\f'
}

method RemoveWhitespaces(s: string) returns (v: string)
    ensures |v| <= |s|
    ensures forall i :: 0 <= i < |v| ==> !IsWhitespace(v[i])
    ensures forall i, j :: 0 <= i < |s| && 0 <= j < |v| && v[j] == s[i] ==> !IsWhitespace(s[i]) && (forall k :: 0 <= k < j ==> v[k] == s[?k]) // order preservation
{
    var s' : string := [];
    for i := 0 to |s|
        invariant 0 <= i <= |s|
        invariant |s'| == CountNonWhitespace(s, 0, i)
        invariant forall k :: 0 <= k < i ==> !IsWhitespace(s[k]) ==> s[k] == s'[CountNonWhitespace(s, 0, k)]
    {
        if !IsWhitespace(s[i])
        {
            s' := s' + [s[i]];
        }
        // else skip whitespace
    }
    return s';

    // Helper function to count non-whitespace characters in s[0..i-1]
    function CountNonWhitespace(s: string, start: int, end: int): int
        decreases end - start
    {
        if end == start then 0
        else
            var count := CountNonWhitespace(s, start, end - 1);
            if !IsWhitespace(s[end - 1]) then count + 1 else count
    }
}