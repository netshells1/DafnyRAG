method DeepCopySeq<T>(s: seq<T>) returns (copy: seq<T>)
    ensures |copy| == |s|
    ensures forall i :: 0 <= i < |s| ==> copy[i] == s[i]
{
    var c: seq<T> := [];
    for i := 0 to |s|
        invariant 0 <= i <= |s|
        invariant |c| == i
        invariant forall k :: 0 <= k < i ==> c[k] == s[k]
    {
        c := c + [s[i]];
    }
    return c;
}