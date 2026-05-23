predicate InArray(a: array<int>, x: int)
  reads a
{
    exists i :: 0 <= i < a.Length && a[i] == x
}

method RemoveElements(s: array<int>, toRemove: array<int>) returns (result: seq<int>)
    requires s != null
    requires toRemove != null
    ensures forall x :: x in result ==> x in s
    ensures forall x :: x in result ==> x !in toRemove
    ensures multiset(result) == multiset([x | x in s, x !in toRemove])
{
    var res: seq<int> := [];
    var i := 0;
    while i < s.Length
        invariant 0 <= i <= s.Length
        invariant multiset(res) == multiset([x | x in s[0..i], x !in toRemove])
        invariant forall x :: x in res ==> x in s
        invariant forall x :: x in res ==> x !in toRemove
    {
        if !InArray(toRemove, s[i]) && s[i] !in res
        {
            res := res + [s[i]];
        }
        i := i + 1;
    }
    result := res;
}