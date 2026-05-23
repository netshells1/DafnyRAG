method BitwiseXorSeqs(seq1: seq<bit>, seq2: seq<bit>) returns (result: seq<bit>)
    requires seq1 != null
    requires seq2 != null
    requires |seq1| == |seq2|
    ensures result != null
    ensures |result| == |seq1|
    ensures forall i :: 0 <= i < |result| ==> result[i] == seq1[i] ^ seq2[i]
{
    result := new seq<bit>(|seq1|);
    var i := 0;
    while i < |seq1|
        invariant 0 <= i <= |seq1|
        invariant |result| == |seq1|
        invariant forall k :: 0 <= k < i ==> result[k] == seq1[k] ^ seq2[k]
    {
        result[i] := seq1[i] ^ seq2[i];
        i := i + 1;
    }
}