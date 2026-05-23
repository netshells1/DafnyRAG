method MinDifference(a: array<int>) returns (diff: int)
    requires a.Length > 0
    ensures diff >= 0
    ensures exists i, j :: 0 <= i < j < a.Length && diff == |a[i] - a[j]|
    ensures forall i, j :: 0 <= i < j < a.Length ==> diff <= |a[i] - a[j]|
{
    var minDiff := if a.Length >= 2 then |a[0] - a[1]| else 0;
    // Initialize minDiff to a valid value if array has at least two elements, else 0
    
    // Loop over all pairs to find minimal difference
    var i := 0;
    while i < a.Length
        invariant 0 <= i <= a.Length
        invariant minDiff >= 0
        invariant forall k, l :: 0 <= k < l < i ==> minDiff <= |a[k] - a[l]|
    {
        var j := i + 1;
        while j < a.Length
            invariant i + 1 <= j <= a.Length
            invariant minDiff >= 0
            invariant forall k, l :: 0 <= k < l < i ==> minDiff <= |a[k] - a[l]|
            invariant forall k :: 0 <= k < i ==> minDiff <= |a[k] - a[i]| || |a[k] - a[j]| >= minDiff
        {
            var currentDiff := |a[i] - a[j]|;
            if currentDiff < minDiff {
                minDiff := currentDiff;
            }
            j := j + 1;
        }
        i := i + 1;
    }
    diff := minDiff;
}