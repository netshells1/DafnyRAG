method BellPartitionCount(n: nat) returns (ways: nat)
    requires n >= 0
    ensures ways >= 0
    ensures ways == BellNumber(n)
{
    // Use the recursive definition of Bell numbers:
    // Bell(0) = 1
    // Bell(n+1) = sum_{k=0}^{n} C(n, k) * Bell(k)
    var b: array<nat> := new nat[n+1];
    b[0] := 1;
    var i := 1;
    while i <= n
        invariant 1 <= i <= n+1
        invariant forall j: int :: 0 <= j < i ==> b[j] == BellNumber(j)
        invariant b[0] == 1
        invariant b[i-1] == BellNumber(i-1)
    {
        var sum: nat := 0;
        var k := 0;
        while k < i
            invariant 0 <= k <= i
            invariant sum == sum_{j=0}^{k-1} C(i-1, j) * b[j]
        {
            var c := BinomialCoefficient(i-1, k);
            sum := sum + c * b[k];
            k := k + 1;
        }
        b[i] := sum;
        i := i + 1;
    }
    ways := b[n];
}

function method BellNumber(n: nat): nat
    ensures BellNumber(n) >= 0
{
    if n == 0 then 1
    else
        var sum: nat := 0;
        var k := 0;
        while k < n
            invariant 0 <= k <= n
            invariant sum >= 0
        {
            sum := sum + BinomialCoefficient(n-1, k) * BellNumber(k);
            k := k + 1;
        }
        sum
}

function method BinomialCoefficient(n: nat, k: nat): nat
    requires n >= k
    ensures BinomialCoefficient(n, k) >= 0
{
    if k == 0 || k == n then 1
    else BinomialCoefficient(n-1, k-1) + BinomialCoefficient(n-1, k)
}