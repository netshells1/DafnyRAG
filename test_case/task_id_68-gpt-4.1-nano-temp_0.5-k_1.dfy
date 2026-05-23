method IsMonotonic(a: array<int>) returns (monotonic: bool)
    requires a != null
    ensures monotonic <==> (forall i, j :: 0 <= i < j < a.Length ==> a[i] <= a[j]) || (forall i, j :: 0 <= i < j < a.Length ==> a[i] >= a[j])
{
    if a.Length <= 1 {
        // Empty or single-element array is trivially monotonic
        return true;
    }

    var nonDecreasing := true;
    var nonIncreasing := true;

    // Check for non-decreasing and non-increasing behavior
    for i := 0 to a.Length - 2
        invariant 0 <= i < a.Length - 1
        invariant nonDecreasing ==> forall k :: 0 <= k <= i ==> a[k] <= a[k + 1]
        invariant nonIncreasing ==> forall k :: 0 <= k <= i ==> a[k] >= a[k + 1]
    {
        if a[i] > a[i + 1] {
            nonDecreasing := false;
        }
        if a[i] < a[i + 1] {
            nonIncreasing := false;
        }
        // Early exit if both are false
        if !nonDecreasing && !nonIncreasing {
            break;
        }
    }
    monotonic := nonDecreasing || nonIncreasing;
}