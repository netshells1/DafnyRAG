predicate IsEven(n: int)
{
    n % 2 == 0
}

method SumEvenIndexedEvens(arr: array<int>) returns (sum: int)
    requires arr != null
    ensures sum == sumOver(i | 0 <= i < arr.Length && i % 2 == 0 && IsEven(arr[i])) arr[i]
{
    sum := 0;
    var i := 0;
    while i < arr.Length
        invariant 0 <= i <= arr.Length
        invariant sum == sumOver(k | 0 <= k < i && k % 2 == 0 && IsEven(arr[k])) arr[k]
    {
        if i % 2 == 0 && IsEven(arr[i])
        {
            sum := sum + arr[i];
        }
        i := i + 1;
    }
}