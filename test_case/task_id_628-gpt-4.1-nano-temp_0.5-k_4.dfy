predicate IsSpace(c: char)
{
    c == ' '
}

method ReplaceSpaces(s: string) returns (v: string)
    ensures |v| == |s|
    ensures forall i :: 0 <= i < |s| ==> (s[i] == ' ' ==> v[i] == '%') || (s[i] != ' ' ==> v[i] == s[i])
{
    var s' : string := [];
    for i := 0 to |s|
        invariant 0 <= i <= |s|
        invariant |s'| == i
        invariant forall k :: 0 <= k < i ==> (IsSpace(s[k]) ==> s'[k] == '%') && (!IsSpace(s[k]) ==> s'[k] == s[k])
    {
        if IsSpace(s[i]) {
            s' := s' + ['%', '2', '0'];
        } else {
            s' := s' + [s[i]];
        }
    }
    return s';
}