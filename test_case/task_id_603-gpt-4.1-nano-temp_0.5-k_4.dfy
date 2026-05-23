predicate isLucidNumber(x: int)
{
    // Placeholder for actual lucid number definition
    // For demonstration, assume all non-negative integers are lucid
    x >= 0
}

predicate isSorted(s: seq<int>)
{
    forall i :: 0 <= i < |s| - 1 ==> s[i] <= s[i + 1]
}

method GetLucidNumbersUpTo(n: int) returns (result: seq<int>)
    requires n >= 0
    ensures forall i :: 0 <= i < |result| ==> result[i] >= 0
    ensures forall i :: 0 <= i < |result| ==> result[i] <= n
    ensures isSorted(result)
    ensures forall x :: x in result ==> isLucidNumber(x)
{
    var seqBuilder := [];
    var i := 0;
    while i <= n
        invariant 0 <= i <= n + 1
        invariant |seqBuilder| == i
        invariant forall k :: 0 <= k < i ==> isLucidNumber(k)
        invariant isSorted(seqBuilder)
        // The sequence seqBuilder contains all lucid numbers <= i-1
    {
        if isLucidNumber(i) {
            seqBuilder := seqBuilder + [i];
        }
        i := i + 1;
    }
    result := seqBuilder;
}