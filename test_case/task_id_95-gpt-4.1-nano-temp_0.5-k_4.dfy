method MinListLength(lists: seq<seq<int>>) returns (minLength: int)
    requires |lists| > 0
    ensures minLength >= 0
    ensures exists i :: 0 <= i < |lists| && minLength == |lists[i]|
{
    // Initialize minLength with the length of the first inner list
    minLength := |lists[0]|;
    // Loop over all inner lists to find the minimum length
    var i := 1;
    while i < |lists|
        invariant 1 <= i <= |lists|
        invariant minLength >= 0
        invariant exists j :: 0 <= j < i && minLength == |lists[j]|
    {
        if |lists[i]| < minLength {
            minLength := |lists[i]|;
        }
        i := i + 1;
    }
}