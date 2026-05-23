predicate InSeq(s: seq<int>, x: int)
{
    exists i :: 0 <= i < |s| && s[i] == x
}

method ListDifference(a: seq<int>, b: seq<int>) returns (diff: seq<int>)
    requires a != null
    requires b != null
    ensures forall x :: x in diff ==> (InSeq(a, x) != InSeq(b, x))
    ensures forall x :: x in diff ==> (InSeq(a, x) != InSeq(b, x))
    ensures forall i, j :: 0 <= i < j < |diff| ==> diff[i] != diff[j]
{
    var res: seq<int> := [];

    // Add elements in a not in b
    for i := 0 to |a|
        invariant 0 <= i <= |a|
        invariant forall x :: x in res ==> (InSeq(a, x) != InSeq(b, x))
        invariant forall x :: x in res ==> (InSeq(a, x) != InSeq(b, x))
        invariant forall i, j :: 0 <= i < j < |res| ==> res[i] != res[j]
    {
        if !InSeq(b, a[i]) && a[i] !in res
        {
            res := res + [a[i]];
        }
    }

    // Add elements in b not in a
    for i := 0 to |b|
        invariant 0 <= i <= |b|
        invariant forall x :: x in res ==> (InSeq(a, x) != InSeq(b, x))
        invariant forall x :: x in res ==> (InSeq(a, x) != InSeq(b, x))
        invariant forall i, j :: 0 <= i < j < |res| ==> res[i] != res[j]
    {
        if !InSeq(a, b[i]) && b[i] !in res
        {
            res := res + [b[i]];
        }
    }

    diff := res;
}