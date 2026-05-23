predicate IsOdd(n: int)
{
    n % 2 != 0
}

method FilterOddNumbers(arr: array<int>) returns (oddNumbers: seq<int>)
    requires arr != null
    ensures forall i :: 0 <= i < |oddNumbers| ==> IsOdd(oddNumbers[i])
    ensures forall i :: 0 <= i < arr.Length && IsOdd(arr[i]) ==> exists j :: 0 <= j < |oddNumbers| && oddNumbers[j] == arr[i]
{
    var resultSeq := [];
    var i := 0;
    while i < arr.Length
        invariant 0 <= i <= arr.Length
        invariant resultSeq == seq{ for k := 0 to i-1 :: arr[k] in arr[..] && IsOdd(arr[k]) } // sequence of odd elements seen so far
        invariant forall k :: 0 <= k < i ==> IsOdd(arr[k]) ==> arr[k] in resultSeq
    {
        if IsOdd(arr[i]) {
            resultSeq := resultSeq + [arr[i]];
        }
        i := i + 1;
    }
    oddNumbers := resultSeq;
}