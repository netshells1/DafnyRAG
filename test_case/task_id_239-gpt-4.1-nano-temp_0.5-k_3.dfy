method CountSequences(m: int, n: int) returns (count: int)
    requires m > 0
    requires n > 0
    ensures count >= 0
    ensures count == |{ seq: seq<int> | |seq| == n &&
                                    (forall i :: 0 <= i < n - 1 ==> seq[i+1] >= 2 * seq[i]) &&
                                    (forall i :: 0 <= i < n ==> 1 <= seq[i] <= m) }|
{
    // Use a recursive helper method with memoization to count sequences
    var memo: array<array<int>> := new array<array<int>>(n + 1);
    // Initialize memo with None (null)
    for i := 0 to n
        memo[i] := null;
    
    // Define recursive helper
    function method CountSeqs(pos: int, prev: int): int
        requires 0 <= pos <= n
        requires prev >= 1
        ensures 0 <= CountSeqs(pos, prev) // always returns non-negative
    {
        if pos == n then
            1
        else
            var total := 0;
            // The next element must be >= 2 * prev and <= m
            var start := 2 * prev;
            var end := m;
            var countSeq := 0;
            var i := start;
            while i <= end
                invariant 0 <= countSeq <= end - start + 1
                invariant countSeq == |{ j: int | start <= j <= i && (pos + 1) <= n && true }|
            {
                countSeq := countSeq + CountSeqs(pos + 1, i);
                i := i + 1;
            }
            countSeq
    }
    // Count sequences starting with each possible first element
    count := 0;
    var firstStart := 1;
    var i := firstStart;
    while i <= m
        invariant 0 <= count <= m - firstStart + 1
        invariant count == |{ j: int | firstStart <= j <= i && true }|
    {
        count := count + CountSeqs(1, i);
        i := i + 1;
    }
}