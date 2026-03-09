predicate InArray(a: array<int>, x: int)
  reads a
{
  exists i :: 0 <= i < a.Length && a[i] == x
}

method FindSharedElements(a: array<int>, b: array<int>) returns (result: seq<int>)
  requires a != null && b != null
  ensures forall x :: x in result ==> (InArray(a, x) && InArray(b, x))
  ensures forall i, j :: 0 <= i < j < |result| ==> result[i] != result[j]
{
    var res: seq<int> := [];
    var seen: set<int> := {};

    for i := 0 to a.Length
        invariant 0 <= i <= a.Length
        invariant forall x :: x in res ==> InArray(a, x)
        invariant forall x :: x in res ==> InArray(b, x)
        invariant forall x :: x in res ==> x !in seen
        invariant |res| <= a.Length && |res| <= b.Length
    {
        if InArray(b, a[i]) && a[i] !in seen
        {
            res := res + [a[i]];
            seen := seen + {a[i]};
        }
    }

    result := res;
}