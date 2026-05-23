method IsMinHeap(a: array<int>) returns (isHeap: bool)
    requires a != null
    ensures isHeap ==> forall i :: 0 <= i < a.Length / 2 ==> a[i] <= a[2 * i + 1] && (2 * i + 2 < a.Length ==> a[i] <= a[2 * i + 2])
    ensures !isHeap ==> exists i, j :: 0 <= i < a.Length / 2 && (j == 2 * i + 1 || j == 2 * i + 2) && j < a.Length && a[i] > a[j]
{
    isHeap := true;
    var i := 0;
    while i < a.Length / 2
        invariant 0 <= i <= a.Length / 2
        invariant isHeap ==> forall k :: 0 <= k < i ==> a[k] <= a[2 * k + 1] && (2 * k + 2 < a.Length ==> a[k] <= a[2 * k + 2])
        invariant !isHeap ==> exists k, j :: 0 <= k < i && (j == 2 * k + 1 || j == 2 * k + 2) && j < a.Length && a[k] > a[j]
    {
        // Check left child
        if 2 * i + 1 < a.Length && a[i] > a[2 * i + 1] {
            isHeap := false;
            break;
        }
        // Check right child
        if 2 * i + 2 < a.Length && a[i] > a[2 * i + 2] {
            isHeap := false;
            break;
        }
        i := i + 1;
    }
}