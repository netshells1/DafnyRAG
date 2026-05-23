method RemoveDuplicates(a: array<int>) returns (result: array<int>)
    requires a != null
    ensures forall x :: x in result ==> InArray(a, x)
    ensures distinct(result)
    ensures |result| <= a.Length
{
    var resSeq: seq<int> := [];
    var seen: set<int> := {};

    for i := 0 to a.Length
        invariant 0 <= i <= a.Length
        invariant forall x :: x in resSeq ==> InArray(a, x)
        invariant forall x :: x in resSeq ==> x in seen
        invariant distinct(resSeq)
    {
        if a[i] !in seen {
            resSeq := resSeq + [a[i]];
            seen := seen + {a[i]};
        }
    }
    result := resSeq.ToArray();
}