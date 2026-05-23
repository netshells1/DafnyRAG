method RemoveOddChars(s: string) returns (v: string)
    ensures |v| <= |s|
    ensures forall i :: 0 <= i < |v| ==> s[2 * i] == v[i]
    ensures forall i :: 0 <= i < |v| ==> (2 * i) < |s|
{
    var v' : string := "";
    var i := 0;
    while i < |s|
        invariant 0 <= i <= |s|
        invariant |v'| == i / 2
        invariant forall k :: 0 <= k < |v'| ==> s[2 * k] == v'[k]
    {
        if i % 2 == 0
        {
            v' := v' + [s[i]];
        }
        i := i + 1;
    }
    return v';
}