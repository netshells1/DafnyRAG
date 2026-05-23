method IndexWiseAddSequences(seq1: seq<seq<int>>, seq2: seq<seq<int>>) returns (result: seq<seq<int>>)
    requires seq1 != null && seq2 != null
    requires |seq1| == |seq2|
    requires forall i :: 0 <= i < |seq1| ==> |seq1[i]| == |seq2[i]|
    ensures result != null
    ensures |result| == |seq1|
    ensures forall i :: 0 <= i < |result| ==> |result[i]| == |seq1[i]| + |seq2[i]|
{
    var resSeq := new seq<int>[|seq1|];
    var i := 0;
    while i < |seq1|
        invariant 0 <= i <= |seq1|
        invariant resSeq[..i] == [ for j | 0 <= j < i :: seq1[j] + seq2[j] ]
    {
        var innerSum := new int[|seq1[i]|];
        var j := 0;
        while j < |seq1[i]|
            invariant 0 <= j <= |seq1[i]|
            invariant innerSum[..j] == [ for k | 0 <= k < j :: seq1[i][k] + seq2[i][k] ]
        {
            innerSum[j] := seq1[i][j] + seq2[i][j];
            j := j + 1;
        }
        resSeq[i] := innerSum;
        i := i + 1;
    }
    result := resSeq;
}