// Helper function to compute 10^k
function Power10(k: nat): nat
    ensures Power10(0) == 1
    ensures Power10(k) >= 1
{
    if k == 0 then 1 else 10 * Power10(k - 1)
}

// Recursive function to join array elements into a single integer
function JoinArrayHelper(a: array<int>): int
    requires a != null
{
    var n := a.Length;
    if n == 0 then 0
    else
        var prefix := JoinArrayHelper(a[0..n - 1]);
        var shift := Power10(LengthDigits(a[n - 1]));
        prefix * shift + a[n - 1]
}

// Helper function to compute number of digits in a non-negative integer
function LengthDigits(x: int): nat
    requires x >= 0
{
    if x < 10 then 1 else 1 + LengthDigits(x / 10)
}

method JoinArray(a: array<int>) returns (result: int)
    requires a != null
    requires forall i :: 0 <= i < a.Length ==> a[i] >= 0
    ensures result == JoinArrayHelper(a)
{
    result := JoinArrayHelper(a);
}