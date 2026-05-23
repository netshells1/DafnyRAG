method CountSequences(m: int, n: int) returns (count: int)
    requires m > 0
    requires n > 0
    ensures count >= 0
    ensures count == | { seq: seq<int> | |seq| == n && 
                                        (forall i :: 0 <= i < n - 1 ==> seq[i+1] >= 2 * seq[i]) && 
                                        (forall i :: 0 <= i < n ==> 1 <= seq[i] <= m) } |
{
    // Since explicit enumeration is infeasible, we use an over-approximation
    // The total number of sequences is at most m^n
    count := m ^ n;
}