method SeqSubtract(seq1: seq<int>, seq2: seq<int>) returns (result: seq<int>)
    requires |seq1| == |seq2|
    ensures |result| == |seq1|
    ensures forall i :: 0 <= i < |result| ==> result[i] == seq1[i] - seq2[i]
{
    var res := [];
    var i := 0;
    while i < |seq1|
        invariant 0 <= i <= |seq1|
        invariant |res| == i
        invariant forall j :: 0 <= j < i ==> res[j] == seq1[j] - seq2[j]
    {
        res := res + [seq1[i] - seq2[i]];
        i := i + 1;
    }
    result := res;
}