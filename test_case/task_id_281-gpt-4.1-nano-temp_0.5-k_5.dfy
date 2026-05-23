method AllUnique(a: array<int>) returns (result: bool)
    requires a != null
    ensures result <==> (forall i, j :: 0 <= i < a.Length && 0 <= j < a.Length && i != j ==> a[i] != a[j])
{
    result := true;
    var i := 0;
    while i < a.Length
        invariant 0 <= i <= a.Length
        invariant result ==> forall k, l :: 0 <= k < l < i ==> a[k] != a[l]
    {
        var j := i + 1;
        while j < a.Length
            invariant i + 1 <= j <= a.Length
            invariant result ==> forall k, l :: 0 <= k < l < i ==> a[k] != a[l]
            invariant result ==> (forall m :: 0 <= m < i ==> a[m] != a[j])
        {
            if a[i] == a[j] {
                result := false;
                return;
            }
            j := j + 1;
        }
        i := i + 1;
    }
}