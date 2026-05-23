method Interleave3Sequences(s1: seq<int>, s2: seq<int>, s3: seq<int>) returns (result: seq<int>)
    requires |s1| == |s2| == |s3|
    ensures |result| == 3 * |s1|
    ensures forall i :: 0 <= i < |s1| ==> result[3*i] == s1[i]
    ensures forall i :: 0 <= i < |s2| ==> result[3*i + 1] == s2[i]
    ensures forall i :: 0 <= i < |s3| ==> result[3*i + 2] == s3[i]
{
    var n := |s1|;
    result := [];

    var i := 0;
    while i < n
        invariant 0 <= i <= n
        invariant |result| == 3 * i
        invariant forall k :: 0 <= k < i ==> result[3*k] == s1[k]
        invariant forall k :: 0 <= k < i ==> result[3*k + 1] == s2[k]
        invariant forall k :: 0 <= k < i ==> result[3*k + 2] == s3[k]
    {
        result := result + [s1[i], s2[i], s3[i]];
        i := i + 1;
    }
}