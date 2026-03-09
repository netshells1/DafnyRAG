predicate InArray(a: array<int>, x: int)
  reads a
{
    exists i :: 0 <= i < a.Length && a[i] == x
}

method SharedElements(a: array<int>, b: array<int>) returns (result: seq<int>)
    requires a != null && b != null
    ensures forall x :: x in result ==> (InArray(a, x) && InArray(b, x))
    ensures forall i, j :: 0 <= i < j < |result| ==> result[i] != result[j]
{
    var res: seq<int> := [];
    for i := 0 to a.Length
        invariant 0 <= i <= a.Length
        invariant forall x :: x in res ==> InArray(a, x)
        invariant forall x :: x in res ==> InArray(b, x)
        invariant forall i, j :: 0 <= i < j < |res| ==> res[i] != res[j]
    {
        if InArray(b, a[i]) && a[i] !in res
        {
            res := res + [a[i]];
        }
    }

    // Remove duplicates if any (though the above ensures no duplicates are added)
    // For safety, we can filter duplicates
    var uniqueRes: seq<int> := [];
    for x in res
        invariant forall y :: y in uniqueRes ==> y != x
    {
        if x !in uniqueRes
        {
            uniqueRes := uniqueRes + [x];
        }
    }

    result := uniqueRes;
}