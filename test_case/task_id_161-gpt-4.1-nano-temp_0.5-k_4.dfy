predicate InArray(a: array<int>, x: int)
  reads a
{
    exists i :: 0 <= i < a.Length && a[i] == x
}

method RemoveElements(s: array<int>, toRemove: array<int>) returns (result: array<int>)
    requires s != null && toRemove != null
    ensures result != null
    ensures forall x :: x in result ==> !InArray(toRemove, x)
    ensures forall x :: x in s ==> (InArray(toRemove, x) ==> x !in result)
    ensures forall i, j :: 0 <= i < j < |result| ==> result[i] != result[j]
{
    var res: seq<int> := [];
    for i := 0 to s.Length
        invariant 0 <= i <= s.Length
        invariant forall x :: x in res ==> InArray(s, x)
        invariant forall x :: x in res ==> !InArray(toRemove, x)
        invariant forall i, j :: 0 <= i < j < |res| ==> res[i] != res[j]
    {
        if !InArray(toRemove, s[i]) && s[i] !in res
        {
            res := res + [s[i]];
        }
    }
    result := res;
}