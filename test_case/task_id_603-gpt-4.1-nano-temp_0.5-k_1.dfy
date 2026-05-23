method GetLucidNumbers(n: int) returns (result: seq<int>)
    requires n >= 0
    ensures forall k :: 0 <= k < |result| ==> result[k] >= 0 && result[k] <= n
    ensures IsSorted(result)
    ensures |result| == n + 1
    ensures result[0] == 0
    ensures result[|result|-1] == n
{
    var seqBuilder := [];
    var i := 0;
    while i <= n
        invariant 0 <= i <= n + 1
        invariant |seqBuilder| == i
        invariant forall k :: 0 <= k < i ==> seqBuilder[k] == k
    {
        seqBuilder := seqBuilder + [i];
        i := i + 1;
    }
    result := seqBuilder;
}