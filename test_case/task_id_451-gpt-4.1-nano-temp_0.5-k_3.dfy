predicate IsWhitespace(c: char)
{
    c == ' ' || c == '\t' || c == '\n' || c == '\r'
}

method RemoveWhitespaces(s: string) returns (v: string)
    ensures |v| <= |s|
    ensures forall i :: 0 <= i < |v| ==> !IsWhitespace(v[i])
    ensures forall i, j :: 0 <= i < |s| && 0 <= j < |v| && v[j] == s[i] ==> !IsWhitespace(s[i])
{
    var s' : string := [];
    for i := 0 to |s|
        invariant 0 <= i <= |s|
        invariant |s'| <= i
        invariant forall k :: 0 <= k < |s'| ==> v[k] == s[k] && !IsWhitespace(s[k])
        {
            if !IsWhitespace(s[i])
            {
                s' := s' + [s[i]];
            }
        }
    v := s';
}