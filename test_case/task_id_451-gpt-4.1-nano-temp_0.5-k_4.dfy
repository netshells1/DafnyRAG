predicate IsWhitespace(c: char)
{
    c == ' ' || c == '\t' || c == '\n' || c == '\r' || c == '\v' || c == '\f'
}

method RemoveWhitespaces(s: string) returns (v: string)
    ensures |v| == |s| - CountWhitespace(s)
    ensures forall i :: 0 <= i < |v| ==> exists k :: 0 <= k < |s| && s[k] == v[i] && !IsWhitespace(s[k])
{
    var s' : string := [];
    var countWhitespace := 0;
    for i := 0 to |s|
        invariant 0 <= i <= |s|
        invariant |s'| == i - countWhitespace
        invariant countWhitespace >= 0
        invariant forall k :: 0 <= k < i ==> (IsWhitespace(s[k]) ==> true)
        // No need for a separate invariant here, but we track countWhitespace
    {
        if !IsWhitespace(s[i])
        {
            s' := s' + [s[i]];
        }
        else
        {
            countWhitespace := countWhitespace + 1;
        }
    }
    return s';
}

function CountWhitespace(s: string): nat
{
    var count := 0;
    for c in s
        invariant count <= |s|
        decreases |s| - count
    {
        if IsWhitespace(c) {
            count := count + 1;
        }
    }
    count
}