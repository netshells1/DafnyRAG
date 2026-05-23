method ElementwiseAndSeq(seq1: seq<int>, seq2: seq<int>) returns (result: seq<int>)
    requires seq1 != null
    requires seq2 != null
    ensures result != null
    ensures result.Length == seq1.Length
    ensures forall i :: 0 <= i < result.Length ==> result[i] == seq1[i] & seq2[i]
{
    var res := [];
    var i := 0;
    while i < seq1.Length
        invariant 0 <= i <= seq1.Length
        invariant result == res
        invariant forall j :: 0 <= j < i ==> res[j] == seq1[j] & seq2[j]
    {
        res := res + [seq1[i] & seq2[i]];
        i := i + 1;
    }
    result := res;
}