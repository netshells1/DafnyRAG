method MaxProductPair(a: array<int>) returns (maxProduct: int, index1: int, index2: int)
    requires a != null
    requires a.Length >= 2
    ensures 0 <= index1 < a.Length
    ensures 0 <= index2 < a.Length
    ensures index1 != index2
    ensures maxProduct == (a[index1] * a[index2])
    ensures forall i, j :: 0 <= i < a.Length && 0 <= j < a.Length && i != j ==> a[i] * a[j] <= maxProduct
{
    var maxProd := a[0] * a[1];
    var maxIdx1 := 0;
    var maxIdx2 := 1;
    var i, j: int;
    i := 0;
    while i < a.Length - 1
        invariant 0 <= i <= a.Length - 1
        invariant maxProd == (a[maxIdx1] * a[maxIdx2])
        invariant 0 <= maxIdx1 < a.Length
        invariant 0 <= maxIdx2 < a.Length
        invariant maxIdx1 != maxIdx2
        invariant forall x, y :: 0 <= x < a.Length && 0 <= y < a.Length && x != y ==> a[x] * a[y] <= maxProd
    {
        j := i + 1;
        while j < a.Length
            invariant i + 1 <= j <= a.Length
            invariant maxProd == (a[maxIdx1] * a[maxIdx2])
            invariant 0 <= maxIdx1 < a.Length
            invariant 0 <= maxIdx2 < a.Length
            invariant maxIdx1 != maxIdx2
            invariant forall x, y :: 0 <= x < a.Length && 0 <= y < a.Length && x != y ==> a[x] * a[y] <= maxProd
        {
            if a[i] * a[j] > maxProd {
                maxProd := a[i] * a[j];
                maxIdx1 := i;
                maxIdx2 := j;
            }
            j := j + 1;
        }
        i := i + 1;
    }
    maxProduct := maxProd;
    index1 := maxIdx1;
    index2 := maxIdx2;
}