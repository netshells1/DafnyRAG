method MaxProductPair(a: array<int>) returns (maxProduct: int, index1: int, index2: int)
    requires a != null
    requires a.Length >= 2
    ensures 0 <= index1 < a.Length
    ensures 0 <= index2 < a.Length
    ensures index1 != index2
    ensures maxProduct == a[index1] * a[index2]
{
    var maxProd := a[0] * a[1];
    var maxIdx1 := 0;
    var maxIdx2 := 1;
    
    var n := a.Length;
    
    var i := 0;
    while i < n - 1
        invariant 0 <= i <= n - 1
        invariant maxProd == a[maxIdx1] * a[maxIdx2]
        invariant 0 <= maxIdx1 < n
        invariant 0 <= maxIdx2 < n
        invariant maxIdx1 != maxIdx2
        invariant forall j, k :: 0 <= j < k < i + 1 ==> a[j] * a[k] <= maxProd
    {
        var j := i + 1;
        while j < n
            invariant i + 1 <= j <= n
            invariant maxProd == a[maxIdx1] * a[maxIdx2]
            invariant 0 <= maxIdx1 < n
            invariant 0 <= maxIdx2 < n
            invariant maxIdx1 != maxIdx2
            invariant forall x, y :: 0 <= x < y < j ==> a[x] * a[y] <= maxProd
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