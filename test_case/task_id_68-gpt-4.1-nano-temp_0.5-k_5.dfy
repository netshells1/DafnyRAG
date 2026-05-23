method IsMonotonic(a: array<int>) returns (monotonic: bool)
    requires a != null
    ensures monotonic <==> (forall i, j :: 0 <= i < j < a.Length ==> a[i] <= a[j]) || (forall i, j :: 0 <= i < j < a.Length ==> a[i] >= a[j])
{
    var nonDecreasing := true;
    var nonIncreasing := true;

    for i := 0 to a.Length - 2
        invariant 0 <= i <= a.Length - 2
        invariant nonDecreasing ==> forall k, l :: 0 <= k < l <= i ==> a[k] <= a[l]
        invariant nonIncreasing ==> forall k, l :: 0 <= k < l <= i ==> a[k] >= a[l]
    {
        if a[i] > a[i + 1] {
            nonDecreasing := false;
        }
        if a[i] < a[i + 1] {
            nonIncreasing := false;
        }
        if !nonDecreasing && !nonIncreasing {
            break;
        }
    }
    monotonic := nonDecreasing || nonIncreasing;
}