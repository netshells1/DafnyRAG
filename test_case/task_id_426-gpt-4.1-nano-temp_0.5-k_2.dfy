predicate IsOdd(n: int)
{
    n % 2 != 0
}

method FilterOddNumbers(arr: array<int>) returns (odds: seq<int>)
    requires arr != null
    ensures forall i :: 0 <= i < |odds| ==> IsOdd(odds[i])
    ensures odds == [ for i | 0 <= i < arr.Length :: if IsOdd(arr[i]) then arr[i] else |[] |]
{
    odds := [];
    var i := 0;
    while i < arr.Length
        invariant 0 <= i <= arr.Length
        invariant |odds| == |[ for j | 0 <= j < i :: if IsOdd(arr[j]) then arr[j] else |[] |]|
        invariant forall k :: 0 <= k < |odds| ==> IsOdd(odds[k])
    {
        if IsOdd(arr[i])
        {
            odds := odds + [arr[i]];
        }
        i := i + 1;
    }
}