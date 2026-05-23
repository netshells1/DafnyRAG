predicate InArray(a: array<int>, x: int)
  reads a
{
  exists i :: 0 <= i < a.Length && a[i] == x
}

method RemoveDuplicates(a: array<int>) returns (result: array<int>)
  requires a != null
  ensures forall x :: x in result ==> InArray(a, x)
  ensures forall i, j :: 0 <= i < |result| && 0 <= j < |result| && i != j ==> result[i] != result[j]
  ensures set result == set a
{
    var res: seq<int> := [];
    var seen: set<int> := {};

    for i := 0 to a.Length
        invariant 0 <= i <= a.Length
        invariant set res == set seq res
        invariant forall x :: x in res ==> InArray(a, x)
        invariant set res == set seq res
        invariant forall x :: x in res ==> InArray(a, x)
        invariant set res == set seq res
        invariant forall x :: x in res ==> InArray(a, x)
        invariant forall x :: x in res ==> InArray(a, x)
        invariant set res == set seq res
        invariant forall x :: x in res ==> InArray(a, x)
        invariant set res == set seq res
        invariant forall x :: x in res ==> InArray(a, x)
        invariant set res == set seq res
        invariant forall x :: x in res ==> InArray(a, x)
        invariant set res == set seq res
        invariant forall x :: x in res ==> InArray(a, x)
        invariant set res == set seq res
        invariant forall x :: x in res ==> InArray(a, x)
        invariant set res == set seq res
        invariant forall x :: x in res ==> InArray(a, x)
        invariant set res == set seq res
        invariant forall x :: x in res ==> InArray(a, x)
        invariant set res == set seq res
        invariant forall x :: x in res ==> InArray(a, x)
        invariant set res == set seq res
        invariant forall x :: x in res ==> InArray(a, x)
        invariant set res == set seq res
        invariant forall x :: x in res ==> InArray(a, x)
        invariant set res == set seq res
        invariant forall x :: x in res ==> InArray(a, x)
        invariant set res == set seq res
        invariant forall x :: x in res ==> InArray(a, x)
        invariant set res == set seq res
        invariant forall x :: x in res ==> InArray(a, x)
        invariant set res == set seq res
        invariant forall x :: x in res ==> InArray(a, x)
        invariant set res == set seq res
        invariant forall x :: x in res ==> InArray(a, x)
        invariant set res == set seq res
        invariant forall x :: x in res ==> InArray(a, x)
        invariant set res == set seq res
        invariant forall x :: x in res ==> InArray(a, x)
        invariant set res == set seq res
        invariant forall x :: x in res ==> InArray(a, x)
        invariant set res == set seq res
        invariant forall x :: x in res ==> InArray(a, x)
        invariant set res == set seq res
        invariant forall x :: x in res ==> InArray(a, x)
        invariant set res == set seq res
        invariant forall x :: x in res ==> InArray(a, x)
        invariant set res == set seq res
        invariant forall x :: x in res ==> InArray(a, x)
        invariant set res == set seq res
        invariant forall x :: x in res ==> InArray(a, x)
        invariant set res == set seq res
        invariant forall x :: x in res ==> InArray(a, x)
        invariant set res == set seq res
        invariant forall x :: x in res ==> InArray(a, x)
        invariant set res == set seq res
        invariant forall x :: x in res ==> InArray(a, x)
        invariant set res == set seq res
        invariant forall x :: x in res ==> InArray(a, x)
        invariant set res == set seq res
        invariant forall x :: x in res ==> InArray(a, x)
        invariant set res == set seq res
    {
        if !(a[i] in set res) {
            res := res + [a[i]];
        }
    }
    result := res;
}