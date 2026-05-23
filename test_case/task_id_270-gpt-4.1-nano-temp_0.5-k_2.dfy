predicate IsEven(n: int)
{
    n % 2 == 0
}

method SumEvenPositionEvens(arr: array<int>) returns (sum: int)
    requires arr != null
    ensures sum == sumOverIndices(0, arr.Length - 1, i => if i % 2 == 0 && IsEven(arr[i]) then arr[i] else 0)
{
    sum := 0;
    var i := 0;
    for i := 0 to arr.Length - 1
        invariant 0 <= i <= arr.Length
        invariant sum == sumOverIndices(0, i - 1, j => if j % 2 == 0 && IsEven(arr[j]) then arr[j] else 0)
    {
        if i % 2 == 0 && IsEven(arr[i]) {
            sum := sum + arr[i];
        }
    }
}

// Helper function to sum over a range with a predicate
function sumOverIndices(start: int, end: int, f: int -> int): int
    requires 0 <= start <= end + 1
    requires end < 1000000 // arbitrary large limit to ensure termination
{
    if start > end then 0
    else f(start) + sumOverIndices(start + 1, end, f)
}