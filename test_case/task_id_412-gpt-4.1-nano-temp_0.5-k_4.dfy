predicate IsEven(n: int)
{
    n % 2 == 0
}

method RemoveOddNumbers(arr: array<int>) returns (result: array<int>)
    requires arr != null
    ensures forall i :: 0 <= i < |result| ==> IsEven(result[i])
    ensures forall i :: 0 <= i < arr.Length && IsEven(arr[i]) ==> exists k :: 0 <= k < |result| && result[k] == arr[i]
    ensures multiset(result) == multiset([x | x := arr[..]; IsEven(x)])
{
    var tempList := [];
    var i := 0;
    while i < arr.Length
        invariant 0 <= i <= arr.Length
        invariant multiset(tempList) == multiset([x | x := arr[..i]; IsEven(x)])
        invariant forall k :: 0 <= k < i ==> IsEven(arr[k])
    {
        if IsEven(arr[i])
        {
            tempList := tempList + [arr[i]];
        }
        i := i + 1;
    }
    result := tempList;
}