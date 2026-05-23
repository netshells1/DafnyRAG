method FindUniqueElement(arr: array<int>) returns (result: int)
    requires arr != null
    requires arr.Length > 0
    // Assumption: arr is sorted, contains exactly one element that appears once, others twice
    ensures arr[result] == arr[result]
    ensures (forall i :: 0 <= i < arr.Length && i != result ==> arr[i] != arr[result])
{
    var low := 0;
    var high := arr.Length - 1;

    while low <= high
        invariant 0 <= low <= high + 1
        invariant -1 <= result <= arr.Length - 1
        invariant (result == -1) ==> (exists i :: 0 <= i < arr.Length && (i == 0 || arr[i] != arr[i - 1]) && (i == arr.Length - 1 || arr[i] != arr[i + 1]))
        invariant (result != -1) ==> arr[result] == arr[result]
    {
        var mid := low + (high - low) / 2;

        // Check neighbors to determine if mid is the unique element
        var leftSame := if mid > 0 then arr[mid] == arr[mid - 1] else false;
        var rightSame := if mid < arr.Length - 1 then arr[mid] == arr[mid + 1] else false;

        if !leftSame && !rightSame
        {
            result := mid;
            return;
        }
        else if leftSame
        {
            // The pair is on the left side
            // Determine which side to search
            var countLeft := mid - 1;
            // Count how many elements are on the left
            // Since array is sorted, the unique element is on the side where the pairing breaks
            if (countLeft % 2 == 0)
            {
                low := mid + 1;
            }
            else
            {
                high := mid - 1;
            }
        }
        else
        {
            // The pair is on the right side
            var countRight := arr.Length - mid - 1;
            if (countRight % 2 == 0)
            {
                high := mid - 1;
            }
            else
            {
                low := mid + 1;
            }
        }
    }
    // If not found in loop, the unique element is at low
    result := low;
}