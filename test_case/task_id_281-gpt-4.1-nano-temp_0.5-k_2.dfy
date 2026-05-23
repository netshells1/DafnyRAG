method AllElementsUnique(a: array<int>) returns (result: bool)
    requires a != null
    ensures result <==> (forall i, j :: 0 <= i < j < a.Length ==> a[i] != a[j])
{
    result := true;
    var i := 0;
    while i < a.Length
        invariant 0 <= i <= a.Length
        invariant result <==> (forall x, y :: 0 <= x < y < i ==> a[x] != a[y])
    {
        var j := i + 1;
        while j < a.Length
            invariant i + 1 <= j <= a.Length
            invariant result <==> (forall x, y :: 0 <= x < y < i ==> a[x] != a[y]) && 
                        (forall x :: 0 <= x < i ==> forall y :: j <= y < a.Length ==> a[x] != a[y])
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