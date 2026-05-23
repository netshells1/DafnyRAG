method RemoveOddChars(s: string) returns (v: string)
    ensures |v| == (|s| + 1) / 2
    ensures forall i :: 0 <= i < |v| ==> v[i] == s[2 * i]
{
    var v' : string := [];
    var i := 0;
    var j := 0;
    while i < |s|
        invariant 0 <= i <= |s|
        invariant |v'| == j
        invariant forall k :: 0 <= k < j ==> v'[k] == s[2 * k]
        decreases |s| - i
    {
        v' := v' + [s[i]];
        i := i + 2;
        j := j + 1;
    }
    return v';
}