method MaxProductPair(a: array<int>) returns (maxProduct: int, index1: int, index2: int)
    requires a.Length >= 2
    ensures 0 <= index1 < a.Length
    ensures 0 <= index2 < a.Length
    ensures index1 != index2
    ensures maxProduct == a[index1] * a[index2]
    ensures forall i, j :: 0 <= i < a.Length && 0 <= j < a.Length && i != j ==> a[i] * a[j] <= maxProduct
{
    var maxProd := a[0] * a[1];
    var maxI := 0;
    var maxJ := 1;

    var n := a.Length;
    var i := 0;
    while i < n - 1
        invariant 1 <= i <= n - 1
        invariant maxProd == a[maxI] * a[maxJ]
        invariant 0 <= maxI < n
        invariant 0 <= maxJ < n
        invariant maxI != maxJ
        invariant forall x, y :: 0 <= x < n && 0 <= y < n && x != y ==> a[x] * a[y] <= maxProd
    {
        var j := i + 1;
        while j < n
            invariant i + 1 <= j <= n
            invariant maxProd == a[maxI] * a[maxJ]
            invariant 0 <= maxI < n
            invariant 0 <= maxJ < n
            invariant maxI != maxJ
            invariant forall x, y :: 0 <= x < n && 0 <= y < n && x != y ==> a[x] * a[y] <= maxProd
        {
            if a[i] * a[j] > maxProd {
                maxProd := a[i] * a[j];
                maxI := i;
                maxJ := j;
            }
            j := j + 1;
        }
        i := i + 1;
    }
    maxProduct := maxProd;
    index1 := maxI;
    index2 := maxJ;
}