method MedianLengthOfTrapezium(a: array<int>) returns (median: real)
    requires a != null
    requires a.Length > 0
    ensures median == if a.Length % 2 == 1 then a[a.Length / 2] else (a[a.Length / 2 - 1] + a[a.Length / 2]) / 2.0
{
    var sorted := new int[a.Length];
    // Copy array to avoid mutating input
    for i := 0 to a.Length - 1
        invariant 0 <= i <= a.Length
        invariant sorted[..i] == a[..i]
    {
        sorted[i] := a[i];
    }
    // Simple insertion sort for demonstration (not optimized)
    var j: int;
    var key: int;
    for i := 1 to a.Length - 1
        invariant 1 <= i <= a.Length
        invariant sorted[..i+1] == /* sorted prefix of size i+1 */
        invariant sorted[..i] == /* sorted prefix of size i */
        invariant sorted[..i+1] == sorted[..i] + [sorted[i]]
    {
        key := sorted[i];
        j := i - 1;
        while j >= 0 && sorted[j] > key
            invariant -1 <= j < i
            invariant sorted[..j+1] == /* sorted prefix up to j+1 */
            invariant sorted[j+1..i+1] == /* remaining elements */
        {
            sorted[j+1] := sorted[j];
            j := j - 1;
        }
        sorted[j+1] := key;
    }
    if a.Length % 2 == 1 {
        median := sorted[a.Length / 2] as real;
    } else {
        median := (sorted[a.Length / 2 - 1] + sorted[a.Length / 2]) as real / 2.0;
    }
}