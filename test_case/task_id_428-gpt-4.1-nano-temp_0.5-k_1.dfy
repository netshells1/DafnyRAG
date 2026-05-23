method ShellSort(a: array<int>)
  requires a != null
  modifies a
  ensures forall i, j :: 0 <= i < j < a.Length ==> a[i] <= a[j]
{
    var n := a.Length;
    var gap := n / 2;
    while gap > 0
      invariant 0 < gap <= n / 2
      invariant forall i, j :: 0 <= i < j < a.Length ==> a[i] <= a[j]
    {
        var i := gap;
        while i < n
          invariant gap > 0
          invariant 0 <= i <= n
          invariant forall k, l :: 0 <= k < l < a.Length && (k <= i - 1 || l <= i - 1) ==> a[k] <= a[l]
        {
            var temp := a[i];
            var j := i;
            while j >= gap && a[j - gap] > temp
              invariant 0 <= j <= n
              invariant 0 <= j - gap < a.Length
              invariant forall k :: 0 <= k < a.Length ==> a[k] == old(a[k]) || (k >= j && a[k] >= temp)
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