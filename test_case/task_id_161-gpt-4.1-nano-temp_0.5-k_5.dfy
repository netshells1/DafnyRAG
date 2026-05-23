predicate InArray(arr: array<int>, x: int)
  reads arr
{
    exists i :: 0 <= i < arr.Length && arr[i] == x
}

method RemoveElements(s: array<int>, toRemove: array<int>) returns (result: seq<int>)
    requires s != null
    requires toRemove != null
    ensures forall x :: x in result ==> !(x in toRemove)
    ensures forall x :: x in s ==> (x in result) <==> !(x in toRemove)
{
    var res: seq<int> := [];
    var i := 0;
    while i < s.Length
        invariant 0 <= i <= s.Length
        invariant forall x :: x in res ==> !(x in toRemove)
        invariant forall x :: x in s[..i] ==> (x in res) <==> !(x in toRemove)
        decreases s.Length - i
    {
        if !InArray(toRemove, s[i]) && s[i] !in res
        {
            res := res + [s[i]];
        }
        i := i + 1;
    }
    result := res;
}