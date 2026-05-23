method BitwiseXorSeqs(seq1: seq<bv>, seq2: seq<bv>) returns (result: seq<bv>)
    requires |seq1| == |seq2|
    ensures |result| == |seq1|
    ensures forall i :: 0 <= i < |result| ==> result[i] == seq1[i] ^ seq2[i]
{
    result := [];
    var i := 0;
    while i < |seq1|
        invariant 0 <= i <= |seq1|
        invariant |result| == i
        invariant forall j :: 0 <= j < i ==> result[j] == seq1[j] ^ seq2[j]
    {
        result := result + [seq1[i] ^ seq2[i]];
        i := i + 1;
    }
}