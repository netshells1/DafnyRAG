predicate IsWhitespace(c: char)
{
    c == ' ' || c == '\t' || c == '\n' || c == '\r'
}

method RemoveWhitespaces(s: string) returns (v: string)
    ensures |v| <= |s|
    ensures forall i :: 0 <= i < |v| ==> forall k :: 0 <= k < |s| ==> s[k] != ' ' && s[k] != '\t' && s[k] != '\n' && s[k] != '\r'
    ensures forall i :: 0 <= i < |v| ==> exists k :: 0 <= k < |s| && s[k] != ' ' && s[k] != '\t' && s[k] != '\n' && s[k] != '\r' && v[i] == s[k]
    ensures forall k :: 0 <= k < |s| && (s[k] != ' ' && s[k] != '\t' && s[k] != '\n' && s[k] != '\r') ==> exists i :: 0 <= i < |v| && v[i] == s[k]
    ensures |s| >= |v|
{
    var v' : string := [];
    var index := 0;
    for i := 0 to |s|
        invariant 0 <= i <= |s|
        invariant |v'| == index
        invariant forall k :: 0 <= k < i ==> s[k] != ' ' && s[k] != '\t' && s[k] != '\n' && s[k] != '\r'
        invariant forall k :: 0 <= k < i && s[k] != ' ' && s[k] != '\t' && s[k] != '\n' && s[k] != '\r' ==> exists j :: 0 <= j < index && v'[j] == s[k]
        {
            if !IsWhitespace(s[i])
            {
                v' := v' + [s[i]];
                index := index + 1;
            }
        }
    return v';
}