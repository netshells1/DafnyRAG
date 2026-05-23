method IndexWiseAdd(seq1: seq<seq<int>>, seq2: seq<seq<int>>) returns (result: seq<seq<int>>)
    requires |seq1| == |seq2|
    requires forall i :: 0 <= i < |seq1| ==> |seq1[i]| == |seq2[i]|
    ensures |result| == |seq1|
    ensures forall i :: 0 <= i < |result| ==> |result[i]| == [ for j := 0 to |seq1[i]| - 1 :: seq1[i][j] + seq2[i][j] ]
{
    var resSeq := new seq<int>[|seq1|];
    var i := 0;
    while i < |seq1|
        invariant 0 <= i <= |seq1|
        invariant resSeq[..i] == [ for k := 0 to i - 1 :: [ for j := 0 to |seq1[k]| - 1 :: seq1[k][j] + seq2[k][j] ] ]
    {
        var innerRes := new int[|seq1[i]|];
        var j := 0;
        while j < |seq1[i]|
            invariant 0 <= j <= |seq1[i]|
            invariant innerRes[..j] == [ for m := 0 to j - 1 :: seq1[i][m] + seq2[i][m] ]
        {
            innerRes[j] := seq1[i][j] + seq2[i][j];
            j := j + 1;
        }
        resSeq[i] := innerRes[..];
        i := i + 1;
    }
    result := resSeq[..];
}