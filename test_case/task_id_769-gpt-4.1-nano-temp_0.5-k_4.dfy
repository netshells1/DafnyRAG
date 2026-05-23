method ListDifference(a: seq<int>, b: seq<int>) returns (diff: seq<int>)
    ensures forall x :: x in diff ==> x in a && x !in b
{
    var res: seq<int> := [];
    var bSet := set b;
    for x in a
        invariant forall y :: y in res ==> y in a && y !in b
        invariant res == [y | y in a && y in res || y in res]
        // Since sequences are immutable, we build res by appending
    {
        if x !in bSet && x !in res
        {
            res := res + [x];
        }
    }
    diff := res;
}