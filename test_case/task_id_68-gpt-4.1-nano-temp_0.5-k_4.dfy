method IsMonotonic(a: array<int>) returns (monotonic: bool)
  ensures monotonic <==> (forall i, j :: 0 <= i < j < a.Length ==> a[i] <= a[j]) || (forall i, j :: 0 <= i < j < a.Length ==> a[i] >= a[j])
{
    var nonDecreasing := true;
    var nonIncreasing := true;
    var i := 0;
    while i < a.Length - 1
        invariant 0 <= i <= a.Length - 1
        invariant nonDecreasing ==> (forall k, l :: 0 <= k < l <= i ==> a[k] <= a[l])
        invariant nonIncreasing ==> (forall k, l :: 0 <= k < l <= i ==> a[k] >= a[l])
        invariant monotonic <==> (nonDecreasing || nonIncreasing)
    {
        if a[i] > a[i + 1] {
            nonDecreasing := false;
        }
        if a[i] < a[i + 1] {
            nonIncreasing := false;
        }
        i := i + 1;
    }
    monotonic := nonDecreasing || nonIncreasing;
}