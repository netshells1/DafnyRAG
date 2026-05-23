predicate InArray(a: array<int>, x: int)
  reads a
{
  exists i :: 0 <= i < a.Length && a[i] == x
}

predicate NoDuplicates(seq: seq<int>)
{
  forall i, j :: 0 <= i < j < |seq| ==> seq[i] != seq[j]
}

predicate FirstOccurrenceOrder(a: array<int>) : seq<int>
{
  var seen: set<int> := {};
  var res: seq<int> := [];
  for i := 0 to a.Length
    invariant 0 <= i <= a.Length
    invariant res == SeqFromSet(seen)
  {
    var x := a[i];
    if x !in seen {
      seen := seen + {x};
    }
  }
  res
}

method RemoveDuplicates(a: array<int>) returns (result: array<int>)
  requires a != null
  ensures forall x :: x in result ==> InArray(a, x)
  ensures NoDuplicates(result)
  ensures result[..] == FirstOccurrenceOrder(a)
{
    var seen: set<int> := {};
    var res: seq<int> := [];

    for i := 0 to a.Length
      invariant 0 <= i <= a.Length
      invariant res == SeqFromSet(seen)
      invariant forall x :: x in res ==> InArray(a, x)
      invariant NoDuplicates(res)
    {
      var x := a[i];
      if x !in seen {
        seen := seen + {x};
        res := res + [x];
      }
    }
    result := res.ToArray();
}

ghost function SeqFromSet(s: set<int>) : seq<int>
{
  // Converts a set to a sequence, preserving insertion order
  // Since sets are unordered, this function defines an arbitrary order
  // For verification, any fixed order suffices
  // Here, we can define a simple recursive function or use Dafny's built-in features
  // For simplicity, assume a fixed order: sorted order
  var sorted := s.ElementsSorted();
  sorted
}