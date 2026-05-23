predicate InArray(a: array<int>, x: int)
  reads a
{
  exists i :: 0 <= i < a.Length && a[i] == x
}

predicate NoDuplicates(s: seq<int>)
{
  forall i, j :: 0 <= i < j < |s| ==> s[i] != s[j]
}

method RemoveDuplicates(a: array<int>) returns (result: array<int>)
  requires a != null
  ensures forall x :: x in result ==> InArray(a, x)
  ensures NoDuplicates(result)
  ensures |result| <= |a|
  ensures forall x :: x in result ==> InArray(a, x)
{
    var resSeq: seq<int> := [];
    var seen: set<int> := {};

    for i := 0 to a.Length
        invariant 0 <= i <= a.Length
        invariant resSeq == [ for k := 0 to i-1 :: a[k] | a[k] !in seen ]
        invariant seen == { a[k] | 0 <= k < i }
        invariant NoDuplicates(resSeq)
    {
        if a[i] !in seen {
            resSeq := resSeq + [a[i]];
            seen := seen + {a[i]};
        }
    }

    result := resSeq.ToArray();
}