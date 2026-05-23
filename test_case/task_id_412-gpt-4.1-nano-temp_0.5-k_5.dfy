predicate IsEven(n: int)
{
    n % 2 == 0
}

method RemoveOdds(arr: array<int>) returns (result: array<int>)
    requires arr != null
    ensures forall i :: 0 <= i < result.Length ==> IsEven(result[i])
    ensures forall i :: 0 <= i < arr.Length && IsEven(arr[i]) ==> exists j :: 0 <= j < result.Length && result[j] == arr[i]
    ensures |result| == |[ x | x in arr[..] :: IsEven(x)]|
{
    var evens := [];
    var i := 0;
    while i < arr.Length
        invariant 0 <= i <= arr.Length
        invariant evens[..] == [ x | x in arr[....i] :: IsEven(x)]
        invariant forall k :: 0 <= k < |evens| ==> IsEven(evens[k])
    {
        if IsEven(arr[i])
        {
            evens := evens + [arr[i]];
        }
        i := i + 1;
    }
    result := evens;
}