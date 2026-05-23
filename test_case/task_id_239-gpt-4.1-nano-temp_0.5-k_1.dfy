predicate ValidSequence(seq: seq<int>, m: int)
    requires seq != null
{
    |seq| == 0 || (forall i :: 0 <= i < |seq| - 1 ==> seq[i+1] >= 2 * seq[i] && seq[i+1] <= m)
}

method CountSequences(m: int, n: int) returns (count: int)
    requires m > 0 && n >= 1
    ensures count >= 0
    ensures count == | { seq: seq<int> | |seq| == n && ValidSequence(seq, m) } |
{
    // Since counting all sequences explicitly is complex, we implement a recursive helper
    // that counts sequences of length n starting from a given previous element.
    // For the initial call, previous element can be 1 (minimum positive integer).
    
    var total := 0;

    // Recursive helper function
    function method CountSeq(prev: int, length: int): int
        requires length >= 0
        ensures 0 <= CountSeq(prev, length) // always non-negative
        // The function counts sequences of remaining length, starting with previous element prev
    {
        if length == 0 then
            1
        else
            // Count all next elements that satisfy constraints
            var sum := 0;
            var next := 2 * prev;
            while next <= m
                invariant 0 <= next - 2 * prev <= m
                invariant sum >= 0
            {
                sum := sum + CountSeq(next, length - 1);
                next := next + 1;
            }
            sum
    }

    count := CountSeq(1, n);
}