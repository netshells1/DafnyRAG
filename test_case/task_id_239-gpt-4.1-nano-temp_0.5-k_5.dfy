method CountSequences(m: int, n: int) returns (count: int)
    requires m > 0
    requires n > 0
    ensures count >= 0
    ensures count == |{ seq: seq<int> | |seq| == n && 
                                (forall i :: 0 <= i < n - 1 ==> seq[i+1] >= 2 * seq[i]) && 
                                (forall i :: 0 <= i < n ==> 1 <= seq[i] <= m) }|
{
    var total := 0;

    // Recursive helper to generate sequences
    method GenerateSequences(pos: int, prev: int, seq: seq<int>)
        requires 1 <= prev <= m
        requires 0 <= pos <= n
        modifies total
        ensures total >= 0
        // No specific postcondition; counts sequences satisfying constraints
    {
        if pos == n {
            total := total + 1;
        } else {
            var start := max(1, 2 * prev);
            var end := m;
            var i := start;
            while i <= end
                invariant 1 <= i <= m + 1
                invariant pos <= n
                invariant total >= 0
            {
                GenerateSequences(pos + 1, i, seq + [i]);
                i := i + 1;
            }
        }
    }

    // Initiate recursion with all possible starting values
    var i := 1;
    while i <= m
        invariant 1 <= i <= m + 1
        invariant total >= 0
    {
        GenerateSequences(1, i, [i]);
        i := i + 1;
    }
    count := total;
}