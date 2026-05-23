predicate IsOdd(n: int)
{
    n % 2 != 0
}

method FilterOddNumbers(lst: seq<int>) returns (odds: seq<int>)
    ensures forall i :: 0 <= i < |odds| ==> IsOdd(odds[i])
    ensures forall i :: 0 <= i < |odds| ==> exists j :: 0 <= j < |lst| && lst[j] == odds[i] && IsOdd(lst[j])
    ensures |odds| <= |lst|
{
    odds := [];
    var index := 0;
    for i := 0 to |lst|
        invariant 0 <= i <= |lst|
        invariant |odds| == |seq { j | 0 <= j < i && IsOdd(lst[j]) }|
        // The sequence odds contains all odd elements seen so far in order
        {
            if IsOdd(lst[i])
            {
                odds := odds + [lst[i]];
            }
        }
}