predicate IsNegative(x: int)
{
    x < 0
}

method FindNegatives(arr: array<int>) returns (negatives: seq<int>)
    requires arr != null
    ensures forall i :: 0 <= i < |negatives| ==> negatives[i] < 0
    ensures forall i, j :: 0 <= i < j < |negatives| ==> negatives[i] != negatives[j]
    ensures forall i :: 0 <= i < |negatives| ==> exists k :: 0 <= k < arr.Length && arr[k] == negatives[i]
{
    negatives := [];
    var i := 0;
    while i < arr.Length
        invariant 0 <= i <= arr.Length
        invariant forall k :: 0 <= k < |negatives| ==> negatives[k] in arr[..] && IsNegative(negatives[k])
        invariant forall k :: 0 <= k < i ==> exists m :: 0 <= m < arr.Length && arr[m] == negatives[k]
        invariant forall k :: 0 <= k < |negatives| ==> negatives[k] in arr[..] && IsNegative(negatives[k])
        invariant forall k :: 0 <= k < |negatives| ==> exists m :: 0 <= m < arr.Length && arr[m] == negatives[k]
    {
        if arr[i] < 0
        {
            // To avoid duplicates, check if already in negatives
            if !exists j :: 0 <= j < |negatives| && negatives[j] == arr[i]
            {
                negatives := negatives + [arr[i]];
            }
        }
        i := i + 1;
    }
}