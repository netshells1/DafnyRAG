predicate IsNegative(x: int)
{
    x < 0
}

method FindNegativeNumbers(arr: array<int>) returns (negatives: seq<int>)
    requires arr != null
    ensures forall i :: 0 <= i < |negatives| ==> IsNegative(negatives[i])
    ensures forall i :: 0 <= i < arr.Length && IsNegative(arr[i]) ==> exists k :: 0 <= k < |negatives| && negatives[k] == arr[i]
    ensures multiset(negatives) == multiset([a | a in arr[..] | IsNegative(a)])
{
    negatives := [];
    var i := 0;
    while i < arr.Length
        invariant 0 <= i <= arr.Length
        invariant multiset(negatives) == multiset([a | a in arr[..i] | IsNegative(a)])
        invariant forall k :: 0 <= k < |negatives| ==> IsNegative(negatives[k])
        invariant forall k :: 0 <= k < i ==> IsNegative(arr[k])
    {
        if IsNegative(arr[i])
        {
            negatives := negatives + [arr[i]];
        }
        i := i + 1;
    }
}