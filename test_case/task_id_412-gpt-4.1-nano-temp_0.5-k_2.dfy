predicate IsEven(n: int)
{
    n % 2 == 0
}

method RemoveOddNumbers(arr: array<int>) returns (result: array<int>)
    // No preconditions
    ensures forall i :: 0 <= i < |result| ==> IsEven(result[i])
    ensures forall i :: 0 <= i < arr.Length && IsEven(arr[i]) ==> exists j :: 0 <= j < |result| && result[j] == arr[i]
    ensures |result| == |[k | 0 <= k < arr.Length && IsEven(arr[k])]| // Length matches count of even numbers
{
    var evens := [];
    var i := 0;
    while i < arr.Length
        invariant 0 <= i <= arr.Length
        invariant |evens| <= i
        invariant forall k :: 0 <= k < |evens| ==> IsEven(evens[k])
        invariant forall k :: 0 <= k < i ==> IsEven(arr[k]) ==> exists j :: 0 <= j < |evens| && evens[j] == arr[k]
    {
        if IsEven(arr[i]) {
            evens := evens + [arr[i]];
        }
        i := i + 1;
    }
    result := evens;
}