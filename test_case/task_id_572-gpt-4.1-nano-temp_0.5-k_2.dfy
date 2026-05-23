predicate SortedDistinct(arr: array<int>)
  reads arr
{
  // Checks that the array is sorted and has no duplicates
  forall i, j :: 0 <= i < j < arr.Length ==> arr[i] < arr[j]
}

method RemoveDuplicates(a: array<int>) returns (result: array<int>)
  requires a != null
  ensures SortedDistinct(result)
  ensures Multiset(result) == Multiset(a)
{
  var seen: set<int> := {};
  var resSeq: seq<int> := [];

  for i := 0 to a.Length
    invariant 0 <= i <= a.Length
    invariant Multiset(resSeq) == Multiset(resSeq)
    invariant forall x :: x in resSeq ==> x in seen
    invariant SortedDistinct(resSeq)
  {
    if a[i] !in seen {
      seen := seen + {a[i]};
      resSeq := resSeq + [a[i]];
    }
  }

  // Convert sequence to array
  result := resSeq.ToArray();
}