method ShellSort(a: array<int>)
  requires a != null
  modifies a
  ensures IsSorted(a[..])
  ensures multiset(a[..]) == multiset(old(a[..]))
{
    var n := a.Length;
    var gap := n / 2;

    while gap > 0
        invariant 0 < gap <= n / 2 + 1
        invariant multiset(a[..]) == multiset(old(a[..]))
        invariant IsSortedWithinGap(a, gap)
    {
        var i := gap;
        while i < n
            invariant gap > 0
            invariant 0 <= i <= n
            invariant multiset(a[..]) == multiset(old(a[..]))
            invariant IsSortedWithinGap(a, gap)
        {
            var temp := a[i];
            var j := i;

            // Shift earlier gap-sorted elements up until correct location for a[i]
            while j >= gap && a[j - gap] > temp
                invariant 0 <= j <= n
                invariant multiset(a[..]) == multiset(old(a[..]))
                invariant IsSortedWithinGap(a, gap)
            {
                a[j] := a[j - gap];
                j := j - gap;
            }
            a[j] := temp;
            i := i + 1;
        }
        gap := gap / 2;
    }
}

// Helper predicate to specify that the array is sorted within each gap
function IsSortedWithinGap(a: array<int>, gap: int): bool
  reads a
{
    forall i, j :: 0 <= i < j < a.Length && (j - i) % gap == 0 ==> a[i] <= a[j]
}