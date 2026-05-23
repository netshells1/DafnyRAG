predicate IsEven(n: int)
{
    n % 2 == 0
}

method RemoveOdds(arr: array<int>) returns (result: array<int>)
    requires arr != null
    ensures forall i :: 0 <= i < |result| ==> IsEven(result[i])
    ensures multiset(result) == multiset([a | a <- arr[..], IsEven(a)])
    ensures |result| <= arr.Length
{
    var tempList := [];
    var i := 0;
    while i < arr.Length
        invariant 0 <= i <= arr.Length
        invariant multiset(tempList) == multiset([a | a <- arr[..i], IsEven(a)])
        invariant forall k :: 0 <= k < |tempList| ==> IsEven(tempList[k])
    {
        if IsEven(arr[i])
        {
            tempList := tempList + [arr[i]];
        }
        i := i + 1;
    }
    result := tempList;
}