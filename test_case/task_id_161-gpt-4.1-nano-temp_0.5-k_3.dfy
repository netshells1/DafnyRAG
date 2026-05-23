predicate InArray(a: array<int>, x: int)
  reads a
{
    exists i :: 0 <= i < a.Length && a[i] == x
}

method RemoveElements(s: array<int>, toRemove: array<int>) returns (result: seq<int>)
    requires s != null
    requires toRemove != null
    ensures forall x :: x in result ==> (InArray(s, x) && !(x in toRemove))
    ensures forall x :: x in result ==> !(x in toRemove)
    ensures forall i, j :: 0 <= i < j < |result| ==> result[i] == s[i]
{
    var res: seq<int> := [];
    for i := 0 to s.Length
        invariant 0 <= i <= s.Length
        invariant forall x :: x in res ==> InArray(s, x)
        invariant forall x :: x in res ==> !(x in toRemove)
        invariant forall k :: 0 <= k < i ==> InArray(s, s[k])
        invariant forall x :: x in res ==> !(x in toRemove)
        invariant forall x :: x in res ==> (InArray(s, x))
        invariant forall x :: x in res ==> (x !in toRemove)
        invariant forall x :: x in res ==> (InArray(s, x))
        invariant forall x :: x in res ==> (x !in toRemove)
    {
        if !(aContains(toRemove, s[i]))
        {
            res := res + [s[i]];
        }
    }
    result := res;
}

function aContains(arr: array<int>, x: int): bool
  reads arr
{
    exists i :: 0 <= i < arr.Length && arr[i] == x
}