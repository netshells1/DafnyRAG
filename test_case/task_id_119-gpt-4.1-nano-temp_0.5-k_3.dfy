method FindUniqueElement(arr: array<int>) returns (result: int)
    requires arr != null
    // Assumption: arr is sorted and contains exactly one element appearing once
    ensures arr[result] == arr[result]
    ensures forall i :: 0 <= i < arr.Length && i != result ==> arr[i] != arr[result]
    ensures forall i :: 0 <= i < arr.Length ==> arr[i] == old(arr[i])
{
    var low := 0;
    var high := arr.Length - 1;
    while low <= high
        invariant 0 <= low <= high + 1
        invariant -1 <= result < arr.Length
        invariant forall i :: 0 <= i < arr.Length ==> arr[i] == old(arr[i])
        invariant (result == -1) ==> (forall i :: 0 <= i < arr.Length && i != result ==> arr[i] != arr[result])
        invariant (result != -1) ==> (arr[result] == arr[result])
    {
        var mid := low + (high - low) / 2;
        // Check neighbors to determine if arr[mid] is the unique element
        var leftNeighbor := if mid > 0 then arr[mid - 1] else -∞;
        var rightNeighbor := if mid < arr.Length - 1 then arr[mid + 1] else -∞;

        if ( (mid == 0 || arr[mid] != arr[mid - 1]) && (mid == arr.Length - 1 || arr[mid] != arr[mid + 1]) ) {
            // arr[mid] is the unique element
            result := mid;
            break;
        } else if (mid > 0 && arr[mid] == arr[mid - 1]) {
            // Pair found on the left side
            var leftCount := (mid) / 2;
            if (leftCount % 2 == 0) {
                // Unique element is on the right
                low := mid + 1;
            } else {
                // Unique element is on the left
                high := mid - 2;
            }
        } else {
            // Pair found on the right side
            var rightCount := (arr.Length - mid - 1) / 2;
            if (rightCount % 2 == 0) {
                // Unique element is on the left
                high := mid - 1;
            } else {
                // Unique element is on the right
                low := mid + 1;
            }
        }
    }
    // If not found in loop, the unique element is at low
    if result == -1 {
        result := low;
    }
}