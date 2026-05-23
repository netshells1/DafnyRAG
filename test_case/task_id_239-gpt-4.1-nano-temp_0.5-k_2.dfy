method CountSequences(m: int, n: int) returns (count: int)
  requires m > 0
  requires n > 0
  ensures count >= 0
  ensures count == |{ seq: seq<int> | |seq| == n && |seq| > 0 && 
             (forall i :: 0 <= i < n - 1 ==> 2 <= seq[i] <= m && seq[i+1] >= 2 * seq[i]) }|
{
    // We will implement a recursive helper to count sequences
    // For verification, we define a recursive function with appropriate invariants
    var total := 0;
    var sequence: seq<int> := [];
    
    // Recursive helper to count sequences starting with current sequence
    function method CountSeqs(currentSeq: seq<int>): int
        requires |currentSeq| <= n
        ensures 0 <= result
    {
        if |currentSeq| == n {
            // Reached desired length, count as 1
            1
        } else {
            var last := currentSeq[|currentSeq|-1];
            var cnt := 0;
            var nextVal := 1;
            // We can iterate over possible next values satisfying constraints
            // To limit the search, we can consider all possible next values
            // from 1 to m, but to optimize, we can consider only values >= 2 * last
            // and <= m
            var start := 2 * last;
            var end := m;
            var i := start;
            while i <= end
                invariant 0 <= i - start <= end - start
                invariant 0 <= start <= i
                invariant start >= 2 * last
                invariant i >= start
                invariant i <= end
                invariant cnt >= 0
            {
                // For counting, just recurse
                var newSeq := currentSeq + [i];
                cnt := cnt + CountSeqs(newSeq);
                i := i + 1;
            }
            cnt
        }
    }

    // Count all sequences starting with each possible first element
    var firstVal := 1;
    while firstVal <= m
        invariant 0 <= firstVal - 1 <= m
        invariant total >= 0
        invariant total == sum of counts over starting firstVal
    {
        total := total + CountSeqs([firstVal]);
        firstVal := firstVal + 1;
    }
    count := total;
}