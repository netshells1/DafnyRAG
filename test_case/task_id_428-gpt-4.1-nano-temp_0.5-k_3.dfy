method ShellSort(a: array<int>)
    requires a != null
    modifies a
    ensures forall i, j :: 0 <= i < j < a.Length ==> a[i] <= a[j]
    ensures multiset(a[..]) == multiset(old(a[..]))
{
    var n := a.Length;
    var gap := n / 2;
    while gap > 0
        invariant 0 < gap <= n / 2 + 1
        invariant multiset(a[..]) == multiset(old(a[..]))
        invariant forall i, j :: 0 <= i < j < a.Length ==> a[i] <= a[j] || exists k, l :: 0 <= k < l < a.Length && a[k] > a[l]
        invariant gap >= 1
        decreases gap
    {
        var i := gap;
        while i < n
            invariant gap > 0
            invariant 0 <= i <= n
            invariant multiset(a[..]) == multiset(old(a[..]))
            invariant forall k, l :: 0 <= k < l < a.Length ==> a[k] <= a[l] || exists m, p :: 0 <= m < p < a.Length && a[m] > a[p]
            invariant i >= gap
        {
            var temp := a[i];
            var j := i;
            while j >= gap && a[j - gap] > temp
                invariant 0 <= j <= n
                invariant multiset(a[..]) == multiset(old(a[..]))
                invariant forall k, l :: 0 <= k < l < a.Length ==> a[k] <= a[l] || exists m, p :: 0 <= m < p < a.Length && a[m] > a[p]
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