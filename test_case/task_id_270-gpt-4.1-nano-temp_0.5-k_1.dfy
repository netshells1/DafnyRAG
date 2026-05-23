predicate IsEven(n: int)
{
    n % 2 == 0
}

method SumEvenNumbersAtEvenPositions(arr: array<int>) returns (sum: int)
    requires arr != null
    ensures sum == sum([ arr[i] | i := 0 .. arr.Length - 1, i % 2 == 0, IsEven(arr[i]) ])
{
    sum := 0;
    var i := 0;
    while i < arr.Length
        invariant 0 <= i <= arr.Length
        invariant sum == sum([ arr[j] | j := 0 .. i - 1, j % 2 == 0, IsEven(arr[j]) ])
    {
        if i % 2 == 0 && IsEven(arr[i])
        {
            sum := sum + arr[i];
        }
        i := i + 1;
    }
}