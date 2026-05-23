method ElementWiseMultiply(seq1: seq<int>, seq2: seq<int>) returns (result: seq<int>)
    requires seq1 != null
    requires seq2 != null
    requires |seq1| == |seq2|
    ensures result != null
    ensures result.Length == seq1.Length
    ensures forall i :: 0 <= i < result.Length ==> result[i] == seq1[i] * seq2[i]
{
    result := new seq<int>(|seq1|);
    var i := 0;
    while i < seq1.Length
        invariant 0 <= i <= seq1.Length
        invariant result != null
        invariant result.Length == seq1.Length
        invariant forall j :: 0 <= j < i ==> result[j] == seq1[j] * seq2[j]
    {
        result := result[0..i] + [seq1[i] * seq2[i]] + result[i+1..];
        i := i + 1;
    }
}