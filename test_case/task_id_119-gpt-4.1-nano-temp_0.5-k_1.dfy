method FindUniqueElement(a: array<int>) returns (element: int)
    requires a != null
    ensures a.Length == 1 ==> element == a[0]
    ensures (a[..] != [] && (forall i :: 0 <= i < a.Length - 1 ==> a[i] != a[i + 1])) ==> 
            (a[0] == element || a[a.Length - 1] == element)
    ensures (a[..] != [] && (exists i :: 0 <= i < a.Length && (i == 0 || a[i] != a[i - 1]) && (i == a.Length - 1 || a[i] != a[i + 1]))) ==> a[i] == element
{
    if a.Length == 1 {
        element := a[0];
        return;
    }
    var low := 0;
    var high := a.Length - 1;
    while low < high
        invariant 0 <= low <= high + 1
        invariant 0 <= high < a.Length
        invariant (forall i :: 0 <= i < low ==> (i == 0 || a[i] != a[i - 1]))
        invariant (forall i :: high < i < a.Length ==> (i == a.Length - 1 || a[i] != a[i + 1]))
    {
        var mid := (low + high) / 2;
        if mid > 0 && a[mid] == a[mid - 1] {
            // Pair is at mid-1 and mid
            if (mid - 1) % 2 == 0 {
                // Pair starts at even index, unique is after
                low := mid + 1;
            } else {
                // Pair starts at odd index, unique is before
                high := mid - 2;
            }
        } else if mid + 1 < a.Length && a[mid] == a[mid + 1] {
            // Pair is at mid and mid+1
            if mid % 2 == 0 {
                // Pair starts at even index, unique is after
                low := mid + 2;
            } else {
                // Pair starts at odd index, unique is before
                high := mid - 1;
            }
        } else {
            // a[mid] is the unique element
            element := a[mid];
            return;
        }
    }
    // When loop ends, low == high, the unique element is at that position
    element := a[low];
}