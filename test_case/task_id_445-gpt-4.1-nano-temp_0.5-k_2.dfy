method ElementWiseMultiply(seq1: seq<int>, seq2: seq<int>) returns (result: seq<int>)
    requires seq1 != null
    requires seq2 != null
    requires |seq1| == |seq2|
    ensures result != null
    ensures |result| == |seq1|
    ensures forall i :: 0 <= i < |result| ==> result[i] == seq1[i] * seq2[i]
{
    result := new int[|seq1|];
    var i := 0;
    while i < |seq1|
        invariant 0 <= i <= |seq1|
        invariant |result| == |seq1|
        invariant forall j :: 0 <= j < i ==> result[j] == seq1[j] * seq2[j]
    {
        result[i] := seq1[i] * seq2[i];
        i := i + 1;
    }
}