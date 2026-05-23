method FindUniqueElement(arr: array<int>) returns (result: int)
    requires arr != null
    requires forall i :: 0 <= i < arr.Length - 1 ==> arr[i] <= arr[i + 1]
    // Assumption: the array contains exactly one element appearing once, others twice
    ensures exists i :: 0 <= i < arr.Length && arr[i] == result && (i == 0 || arr[i - 1] != result) && (i == arr.Length - 1 || arr[i + 1] != result)
    ensures arr[..] == old(arr[..])
{
    var low := 0;
    var high := arr.Length - 1;
    while low < high
        invariant 0 <= low <= high + 1
        invariant high < arr.Length
        invariant forall i :: 0 <= i < arr.Length ==> arr[i] == old(arr[i])
        // Additional invariants can be added for correctness
    {
        var mid := low + (high - low) / 2;
        // Check neighbors to decide which side to search
        if ( (mid == 0 || arr[mid - 1] != arr[mid]) && (mid == arr.Length - 1 || arr[mid + 1] != arr[mid]) )
        {
            result := arr[mid];
            return;
        }
        else if (mid > 0 && arr[mid - 1] == arr[mid])
        {
            // Unique element is in the right half
            // Since pairs are together, move to the right
            if (mid % 2 == 0)
                low := mid + 1;
            else
                high := mid - 1;
        }
        else
        {
            // Unique element is in the left half
            if (mid % 2 == 0)
                high := mid - 1;
            else
                low := mid + 1;
        }
    }
    // When low == high, this is the unique element
    result := arr[low];
}