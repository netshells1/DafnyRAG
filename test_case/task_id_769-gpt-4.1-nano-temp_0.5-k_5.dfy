predicate InSeq(s: seq<int>, x: int)
{
    x in s
}

method ListDifference(a: seq<int>, b: seq<int>) returns (diff: seq<int>)
    ensures forall x :: x in diff ==> x in a && x !in b
    ensures forall x :: x in diff ==> x in a
    ensures forall x :: x in diff ==> x !in b
    ensures forall i, j :: 0 <= i < j < |diff| ==> diff[i] == diff[j] ==> (diff[i] in a && diff[i] !in b)
{
    var res: seq<int> := [];
    var seen: set<int> := {};
    var bSet: set<int> := set b;

    for i := 0 to a.Length
        invariant 0 <= i <= a.Length
        invariant forall x :: x in res ==> x in a && x !in b
        invariant forall x :: x in res ==> x in a
        invariant forall x :: x in res ==> x !in b
        invariant forall x :: x in res ==> x !in seen
        invariant res == seq x | x in a[..i] && x !in b && x !in seen
    {
        if a[i] !in bSet && a[i] !in seen
        {
            res := res + [a[i]];
            seen := seen + {a[i]};
        }
    }
    diff := res;
}