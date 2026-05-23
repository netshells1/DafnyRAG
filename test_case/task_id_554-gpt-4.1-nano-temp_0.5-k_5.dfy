predicate IsOdd(n: int)
{
    n % 2 != 0
}

method FilterOdd(lst: seq<int>) returns (odds: seq<int>)
    ensures forall i :: 0 <= i < |odds| ==> IsOdd(odds[i])
    ensures forall i :: 0 <= i < |lst| ==> (IsOdd(lst[i]) ==> exists j :: 0 <= j < |odds| && odds[j] == lst[i])
    ensures |odds| <= |lst|
    ensures odds == [ x | x <- lst, IsOdd(x) ]
{
    var tmp := [];
    var i := 0;
    // Build the output sequence by filtering odd elements
    while i < |lst|
        invariant 0 <= i <= |lst|
        invariant tmp <= odds
        invariant forall k :: 0 <= k < |tmp| ==> IsOdd(tmp[k])
        // The sequence tmp contains only odd elements from the first i elements of lst
    {
        if IsOdd(lst[i]) {
            tmp := tmp + [lst[i]];
        }
        i := i + 1;
    }
    odds := tmp;
}