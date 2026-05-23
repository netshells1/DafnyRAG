method MaxProductPair(a: array<int>) returns (maxProduct: int, index1: int, index2: int)
    requires a.Length >= 2
    ensures 0 <= index1 < a.Length
    ensures 0 <= index2 < a.Length
    ensures index1 != index2
    ensures maxProduct == a[index1] * a[index2]
    ensures forall i, j :: 0 <= i < a.Length && 0 <= j < a.Length && i != j ==> maxProduct >= a[i] * a[j]
{
    var maxProd := a[0] * a[1];
    var iIdx := 0;
    var jIdx := 1;
    var n := a.Length;
    var i := 0;
    var j := 1;
    while i < n - 1
        invariant 0 <= i <= n - 1
        invariant 1 <= j <= n - 1
        invariant i < j
        invariant maxProd >= a[k] * a[l] for all 0 <= k < i, 0 <= l < j
        decreases n - i
    {
        j := i + 1;
        while j < n
            invariant i < j <= n
            invariant maxProd >= a[k] * a[l] for all 0 <= k < i, 0 <= l < j
            decreases n - j
        {
            if a[i] * a[j] > maxProd {
                maxProd := a[i] * a[j];
                iIdx := i;
                jIdx := j;
            }
            j := j + 1;
        }
        i := i + 1;
    }
    maxProduct := maxProd;
    index1 := iIdx;
    index2 := jIdx;
}