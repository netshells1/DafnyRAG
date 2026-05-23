method ShellSort(a: array<int>)
  modifies a
  ensures forall i, j :: 0 <= i < j < a.Length ==> a[i] <= a[j]
  ensures multiset(a[..]) == old(multiset(a[..]))
{
    var n := a.Length;
    var gap := n / 2;
    while gap > 0
        invariant 0 < gap <= n / 2 + 1
        invariant multiset(a[..]) == old(multiset(a[..]))
        invariant forall i, j :: 0 <= i < j < a.Length && j - i >= gap ==> a[i] <= a[j]
        invariant gap >= 1
        decreases gap
    {
        var i := gap;
        while i < n
            invariant gap > 0
            invariant 0 <= i <= n
            invariant multiset(a[..]) == old(multiset(a[..]))
            invariant forall k :: 0 <= k < i ==> a[k] <= a[k+1]
            invariant forall k :: 0 <= k < i && k + gap < n ==> a[k] <= a[k + gap]
            decreases n - i
        {
            var j := i;
            while j >= gap && a[j - gap] > a[j]
                invariant 0 <= j <= n
                invariant 0 <= j - gap < n
                invariant multiset(a[..]) == old(multiset(a[..]))
                invariant forall k :: 0 <= k < n ==> a[k] == old(a[k]) // elements only moved via swaps
                decreases j
            {
                // Swap a[j] and a[j - gap]
                var temp := a[j];
                a[j] := a[j - gap];
                a[j - gap] := temp;
                j := j - gap;
            }
            i := i + 1;
        }
        gap := gap / 2;
    }
}