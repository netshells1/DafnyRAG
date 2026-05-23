predicate InSeq(s: seq<int>, x: int)
{
    x in s
}

method ListDifference(a: seq<int>, b: seq<int>) returns (diff: seq<int>)
    ensures forall x :: x in diff ==> x in a && x !in b
    ensures forall i, j :: 0 <= i < j < |diff| ==> diff[i] != diff[j]
    ensures forall x :: x in diff ==> x in a
    ensures forall x :: x in diff ==> x !in b
{
    var res: seq<int> := [];

    var seen: set<int> := {};

    var i := 0;
    while i < |a|
        invariant 0 <= i <= |a|
        invariant forall x :: x in res ==> x in a && x !in b
        invariant forall x :: x in res ==> x !in seen
        invariant |res| <= i
        invariant forall x :: x in res ==> x in a
        invariant forall x :: x in res ==> x !in b
    {
        var x := a[i];
        if x !in b && x !in seen {
            res := res + [x];
            seen := seen + {x};
        }
        i := i + 1;
    }
    diff := res;
}