method PairwiseAddNeighbors(seq: seq<int>) returns (result: seq<int>)
    ensures |result| == if |seq| > 0 then |seq| - 1 else 0
    ensures forall i :: 0 <= i < |result| ==> result[i] == seq[i] + seq[i+1]
{
    var res := [];
    var n := |seq|;
    var i := 0;
    while i < n - 1
        invariant 0 <= i <= n
        invariant res == if i == 0 then [] else res[..i]
        invariant |res| == i
        invariant forall j :: 0 <= j < i ==> res[j] == seq[j] + seq[j+1]
    {
        res := res + [seq[i] + seq[i+1]];
        i := i + 1;
    }
    result := res;
}