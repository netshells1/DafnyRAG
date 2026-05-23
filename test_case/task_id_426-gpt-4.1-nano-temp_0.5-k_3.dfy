predicate IsOdd(n: int)
{
    n % 2 != 0
}

method FilterOdds(arr: array<int>) returns (odds: seq<int>)
    ensures forall i :: 0 <= i < |odds| ==> IsOdd(odds[i])
    ensures forall i :: 0 <= i < arr.Length && IsOdd(arr[i]) ==> exists j :: 0 <= j < |odds| && odds[j] == arr[i]
{
    odds := [];
    var i := 0;
    while i < arr.Length
        invariant 0 <= i <= arr.Length
        invariant forall k :: 0 <= k < |odds| ==> IsOdd(odds[k])
        invariant forall k :: 0 <= k < i ==> (IsOdd(arr[k]) ==> exists j :: 0 <= j < |odds| && odds[j] == arr[k])
    {
        if IsOdd(arr[i])
        {
            odds := odds + [arr[i]];
        }
        i := i + 1;
    }
}