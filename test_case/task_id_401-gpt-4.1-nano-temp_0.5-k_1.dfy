method SequenceIndexWiseAdd(seq1: seq<seq<int>>, seq2: seq<seq<int>>) returns (result: seq<seq<int>>)
    requires seq1 != null && seq2 != null
    requires seq1.Length == seq2.Length
    requires forall i :: 0 <= i < seq1.Length ==> seq1[i] != null && seq2[i] != null
    requires forall i :: 0 <= i < seq1.Length ==> seq1[i].Length == seq2[i].Length
    ensures result != null
    ensures result.Length == seq1.Length
    ensures forall i :: 0 <= i < result.Length ==> result[i] != null && result[i].Length == seq1[i].Length
    ensures forall i, j :: 0 <= i < result.Length && 0 <= j < result[i].Length ==> result[i][j] == seq1[i][j] + seq2[i][j]
{
    result := [];
    var i := 0;
    while i < seq1.Length
        invariant 0 <= i <= seq1.Length
        invariant result != null
        invariant result.Length == i
        invariant forall k :: 0 <= k < i ==> result[k] != null && result[k].Length == seq1[k].Length
        invariant forall k, j :: 0 <= k < i && 0 <= j < result[k].Length ==> result[k][j] == seq1[k][j] + seq2[k][j]
    {
        var innerSum := [];
        var j := 0;
        while j < seq1[i].Length
            invariant 0 <= j <= seq1[i].Length
            invariant innerSum != null
            invariant innerSum.Length == j
            invariant forall m :: 0 <= m < j ==> innerSum[m] == seq1[i][m] + seq2[i][m]
        {
            innerSum := innerSum + [seq1[i][j] + seq2[i][j]];
            j := j + 1;
        }
        result := result + [innerSum];
        i := i + 1;
    }
}