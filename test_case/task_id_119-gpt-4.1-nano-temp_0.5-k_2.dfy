method FindUniqueElement(arr: array<int>) returns (result: int?)
    requires arr != null
    requires forall i, j :: 0 <= i < j < arr.Length ==> arr[i] <= arr[j]
    ensures result == null ==> (forall i, j :: 0 <= i < j < arr.Length ==> arr[i] != arr[j])
    ensures result != null ==> (exists i :: 0 <= i < arr.Length && arr[i] == result && (i == 0 || arr[i - 1] != arr[i]) && (i == arr.Length - 1 || arr[i + 1] != arr[i]))
    ensures forall i, j :: 0 <= i < j < arr.Length && arr[i] != result ==> arr[i] != arr[j]
{
    var low := 0;
    var high := arr.Length - 1;
    result := null;

    while low <= high
        invariant 0 <= low <= high + 1 <= arr.Length
        invariant (forall i, j :: 0 <= i < j < arr.Length && (i < low || i > high) ==> arr[i] != arr[j])
        invariant (exists i :: low <= i <= high && (i == 0 || arr[i - 1] != arr[i]) && (i == arr.Length - 1 || arr[i + 1] != arr[i]))
    {
        var mid := low + (high - low) / 2;

        // Check if mid element is unique
        var isUnique := true;

        if mid > 0 && arr[mid] == arr[mid - 1] then
            isUnique := false;
        if mid < arr.Length - 1 && arr[mid] == arr[mid + 1] then
            isUnique := false;

        if isUnique then
        {
            result := arr[mid];
            return;
        }
        else if mid > 0 && arr[mid] == arr[mid - 1] then
        {
            // Pair is on the left side
            // Move high to mid - 2
            high := mid - 2;
        }
        else
        {
            // Pair is on the right side
            // Move low to mid + 2
            low := mid + 2;
        }
    }
    // If no unique element found, result remains null
}