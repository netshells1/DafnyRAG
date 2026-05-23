method PairwiseAddNeighbors(seq: seq<int>) returns (result: seq<int>)
{
    var n := |seq|;
    result := [];
    if n > 1 {
        result := new seq<int>(n - 1);
        var i := 0;
        while i < n - 1
            invariant 0 <= i <= n - 1
            invariant result[..i] == seq[..i] + seq[1..i+1]
        {
            result[i] := seq[i] + seq[i + 1];
            i := i + 1;
        }
    }
}