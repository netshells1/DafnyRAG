method AreElementsUnique(a: array<int>) returns (result: bool)
    requires a != null
    ensures result <==> (forall i, j :: 0 <= i < j < a.Length ==> a[i] != a[j])
{
    result := true;
    var i := 0;
    while i < a.Length
        invariant 0 <= i <= a.Length
        invariant result ==> (forall k, l :: 0 <= k < l < i ==> a[k] != a[l])
        decreases a.Length - i
    {
        var j := i + 1;
        while j < a.Length
            invariant i + 1 <= j <= a.Length
            invariant result ==> (forall k, l :: 0 <= k < l < i ==> a[k] != a[l])
            invariant result ==> (forall m :: i < m < j ==> a[i] != a[m])
            decreases a.Length - j
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