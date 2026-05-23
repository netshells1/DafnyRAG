predicate IsOdd(n: int)
{
    n % 2 != 0
}

method FilterOddNumbers(arr: array<int>) returns (odds: seq<int>)
    ensures forall i :: 0 <= i < |odds| ==> IsOdd(odds[i])
    ensures forall i :: 0 <= i < arr.Length ==> (IsOdd(arr[i]) ==> exists j :: 0 <= j < |odds| && odds[j] == arr[i])
{
    var resultSeq := [];
    if arr != null {
        for i := 0 to arr.Length - 1
            invariant 0 <= i <= arr.Length
            invariant resultSeq == [ for k := 0 to i - 1 :: arr[k] | arr[k] in arr && IsOdd(arr[k]) ]
        {
            if IsOdd(arr[i])
            {
                resultSeq := resultSeq + [arr[i]];
            }
        }
    }
    odds := resultSeq;
}