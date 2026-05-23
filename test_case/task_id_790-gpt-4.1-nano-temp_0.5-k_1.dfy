predicate IsEven(n: int)
{
    n % 2 == 0
}

method AllEvenIndicesContainEvenNumbers(a: array<int>) returns (result: bool)
    ensures result <==> forall i :: 0 <= i < a.Length && i % 2 == 0 ==> IsEven(a[i])
{
    result := true;
    var i := 0;
    while i < a.Length
        invariant 0 <= i <= a.Length
        invariant result <==> forall k :: 0 <= k < i && k % 2 == 0 ==> IsEven(a[k])
    {
        if (i % 2 == 0 && !IsEven(a[i]))
        {
            result := false;
            break;
        }
        i := i + 1;
    }
}