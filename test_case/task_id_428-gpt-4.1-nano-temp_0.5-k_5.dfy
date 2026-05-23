method ShellSort(a: array<int>)
    requires a != null
    modifies a
    ensures forall i, j :: 0 <= i < j < a.Length ==> a[i] <= a[j]
{
    var n := a.Length;
    var gap := n / 2;
    while gap > 0
        invariant 0 < gap <= n / 2
        invariant forall i, j :: 0 <= i < j < n ==> a[i] <= a[j]
        invariant 0 <= i <= n
        invariant 0 <= j <= n
    {
        var i := gap;
        while i < n
            invariant gap > 0
            invariant 0 <= i <= n
            invariant forall k, l :: 0 <= k < l < n ==> a[k] <= a[l]
        {
            var temp := a[i];
            var j := i;
            while j >= gap && a[j - gap] > temp
                invariant 0 <= j <= n
                invariant 0 <= j - gap < n
                invariant forall k, l :: 0 <= k < l < n ==> a[k] <= a[l]
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