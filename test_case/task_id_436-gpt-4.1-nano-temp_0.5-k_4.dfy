predicate IsNegative(n: int)
{
    n < 0
}

method FindNegativeNumbers(arr: array<int>) returns (negatives: seq<int>)
    requires arr != null
    ensures forall i :: 0 <= i < |negatives| ==> IsNegative(negatives[i]) && negatives[i] in arr[..]
    ensures forall i :: 0 <= i < arr.Length && arr[i] < 0 ==> arr[i] in negatives
    ensures |negatives| == countNegatives(arr)
{
    negatives := [];
    var i := 0;
    while i < arr.Length
        invariant 0 <= i <= arr.Length
        invariant forall k :: 0 <= k < |negatives| ==> IsNegative(negatives[k]) && negatives[k] in arr[..]
        invariant forall k :: 0 <= k < i && arr[k] < 0 ==> arr[k] in negatives
        invariant |negatives| == countNegatives(arr[..i])
        invariant forall k :: 0 <= k < i ==> arr[k] != 0
    {
        if arr[i] < 0
        {
            negatives := negatives + [arr[i]];
        }
        i := i + 1;
    }
}