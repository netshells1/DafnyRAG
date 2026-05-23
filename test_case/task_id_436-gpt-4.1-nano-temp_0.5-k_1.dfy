predicate IsNegative(n: int)
{
    n < 0
}

method FindNegativeNumbers(arr: array<int>) returns (negatives: seq<int>)
    // The output sequence contains all negative numbers from arr
    ensures forall i :: 0 <= i < |negatives| ==> negatives[i] in arr[..] && negatives[i] < 0
    // All negative numbers in arr are included in the output
    ensures forall i :: 0 <= i < arr.Length && arr[i] < 0 ==> exists j :: 0 <= j < |negatives| && negatives[j] == arr[i]
    // The length of the output matches the number of negative elements in arr
    ensures |negatives| == |[ for x in arr[..] :: x < 0 ]|
{
    negatives := [];
    for i := 0 to arr.Length
        invariant 0 <= i <= arr.Length
        invariant forall k :: 0 <= k < |negatives| ==> negatives[k] in arr[..] && negatives[k] < 0
        invariant forall k :: 0 <= k < i ==> arr[k] >= 0 || exists j :: 0 <= j < |negatives| && negatives[j] == arr[k]
        // The sequence negatives contains only negatives from the first i elements
        invariant |negatives| <= i
    {
        if IsNegative(arr[i]) {
            negatives := negatives + [arr[i]];
        }
    }
}