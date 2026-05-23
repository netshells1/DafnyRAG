method BitwiseXorSeqs(seqA: seq< bv >, seqB: seq< bv >) returns (result: seq< bv >)
    requires seqA != null && seqB != null
    requires |seqA| == |seqB|
    ensures result != null
    ensures |result| == |seqA|
    ensures forall i :: 0 <= i < |result| ==> result[i] == seqA[i] ^ seqB[i]
{
    result := [];
    var i := 0;
    while i < |seqA|
        invariant 0 <= i <= |seqA|
        invariant |result| == i
        invariant forall j :: 0 <= j < i ==> result[j] == seqA[j] ^ seqB[j]
    {
        result := result + [seqA[i] ^ seqB[i]];
        i := i + 1;
    }
}