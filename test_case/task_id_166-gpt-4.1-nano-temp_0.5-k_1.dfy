predicate IsEven(n: int)
{
    n % 2 == 0
}

method CountXorPairs(arr: array<int>) returns (count: nat)
    requires arr != null
    ensures count == |{ (i, j) | 0 <= i < j < arr.Length && ((arr[i] xor arr[j]) % 2 == 0) }|
{
    count := 0;
    var n := arr.Length;
    var i := 0;
    var j := 0;
    // Loop over all pairs (i, j) with i < j
    while i < n
        invariant 0 <= i <= n
        invariant 0 <= j <= n
        invariant count == |{ (x, y) | 0 <= x < y < i && ((arr[x] xor arr[y]) % 2 == 0) }| + |{ (x, y) | i <= x < y < j && ((arr[x] xor arr[y]) % 2 == 0) }|
        invariant count == |{ (x, y) | 0 <= x < y < j && ((arr[x] xor arr[y]) % 2 == 0) }|
        invariant 0 <= j <= n
    {
        if j < n
        {
            var k := i;
            while k < j
                invariant i <= k <= j
                invariant 0 <= k <= j
                invariant count == |{ (x, y) | 0 <= x < y < i && ((arr[x] xor arr[y]) % 2 == 0) }| + |{ (x, y) | i <= x < y < k && ((arr[x] xor arr[y]) % 2 == 0) }|
                invariant count == |{ (x, y) | 0 <= x < y < j && ((arr[x] xor arr[y]) % 2 == 0) }|
            {
                if ( (arr[k] xor arr[j]) ) % 2 == 0
                {
                    count := count + 1;
                }
                k := k + 1;
            }
            j := j + 1;
        } else
        {
            i := i + 1;
            j := i + 1;
        }
    }
}