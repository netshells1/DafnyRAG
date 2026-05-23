method PairwiseSum(seq: seq<int>) returns (result: seq<int>)
    ensures |result| == |seq| - 1
    ensures forall i :: 0 <= i < |result| ==> result[i] == seq[i] + seq[i + 1]
{
    var res := [];
    var n := |seq|;
    var i := 0;
    while i < n - 1
        invariant 0 <= i <= n
        invariant |res| == i
        invariant forall k :: 0 <= k < i ==> res[k] == seq[k] + seq[k + 1]
    {
        res := res + [seq[i] + seq[i + 1]];
        i := i + 1;
    }
    result := res;
}