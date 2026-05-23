method ListDifference(a: seq<int>, b: seq<int>) returns (diff: seq<int>)
    ensures forall x :: x in diff ==> x in a && x !in b
    ensures forall x :: x in diff ==> x in a
    ensures forall x :: x in diff ==> x !in b
    ensures forall x :: x in a && x !in b ==> x in diff
{
    var res: seq<int> := [];
    var seen: set<int> := {};

    // Iterate over each element in 'a'
    for x in a
        invariant res == res[..]
        invariant forall y :: y in res ==> y in a && y !in b
        invariant seen == set y | y in res
    {
        if x !in b && x !in seen
        {
            res := res + [x];
            seen := seen + {x};
        }
    }
    diff := res;
}