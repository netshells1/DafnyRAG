method FindPerfectSquaresInRange(low: int, high: int) returns (squares: seq<int>)
    requires low <= high
    requires low >= 0
    requires high >= 0
    ensures forall i :: 0 <= i < |squares| ==> exists k: int :: k * k == squares[i] && low <= squares[i] <= high
    ensures forall i, j :: 0 <= i < j < |squares| ==> squares[i] <= squares[j]
    ensures forall sq :: int :: sq in squares ==> low <= sq <= high && exists k: int :: k * k == sq
{
    var result := [];
    var start := 0;
    // Find the smallest integer whose square is >= low
    var k := 0;
    while (k * k < low)
        invariant 0 <= k
        invariant k * k < low ==> true
        invariant start == k
    {
        k := k + 1;
    }
    // Collect all perfect squares between low and high
    var current := k;
    while (current * current <= high)
        invariant 0 <= current
        invariant current * current <= high
        invariant result == [for c in 0..current-1 :: c * c] // sequence of squares up to current-1
        invariant forall c :: 0 <= c < |result| ==> result[c] == c * c
    {
        result := result + [current * current];
        current := current + 1;
    }
    squares := result;
}