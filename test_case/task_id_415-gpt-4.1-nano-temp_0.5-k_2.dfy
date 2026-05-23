method MaxProductPair(a: array<int>) returns (maxProduct: int, index1: int, index2: int)
    requires a.Length >= 2
    ensures 0 <= index1 < a.Length
    ensures 0 <= index2 < a.Length
    ensures index1 != index2
    ensures maxProduct == a[index1] * a[index2]
    ensures maxProduct >= (exists i, j :: 0 <= i < j < a.Length && maxProduct == a[i] * a[j])
{
    var maxProd := a[0] * a[1];
    var maxIdx1 := 0;
    var maxIdx2 := 1;
    var n := a.Length;

    var i := 0;
    while i < n - 1
        invariant 1 <= i <= n - 1
        invariant maxProd == (exists p, q :: 0 <= p < q < i + 1 && maxProd == a[p] * a[q])
        invariant 0 <= maxIdx1 < a.Length
        invariant 0 <= maxIdx2 < a.Length
        invariant maxIdx1 != maxIdx2
    {
        var j := i + 1;
        while j < n
            invariant i + 1 <= j <= n
            invariant maxProd == (exists p, q :: 0 <= p < q < i + 1 && maxProd == a[p] * a[q]) ||
                                (exists p, q :: 0 <= p < j && q == j && maxProd == a[p] * a[q])
            invariant 0 <= maxIdx1 < a.Length
            invariant 0 <= maxIdx2 < a.Length
            invariant maxIdx1 != maxIdx2
        {
            var currentProduct := a[i] * a[j];
            if currentProduct > maxProd {
                maxProd := currentProduct;
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