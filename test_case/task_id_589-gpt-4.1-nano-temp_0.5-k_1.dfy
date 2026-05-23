method FindPerfectSquaresInRange(lower: int, upper: int) returns (squares: seq<int>)
    requires lower >= 0
    requires lower <= upper
    ensures forall s :: s in squares ==> lower <= s <= upper && exists i: int :: i * i == s
    ensures sorted(squares)
    ensures forall s :: s in squares ==> IsPerfectSquare(s)
{
    squares := [];
    var start := 0;
    // Find the smallest i such that i * i >= lower
    while start * start < lower
        invariant 0 <= start
        invariant start * start < lower ==> True
        invariant start * start >= lower || start == 0
    {
        start := start + 1;
    }
    var i := start;
    // Collect all perfect squares in [lower, upper]
    while i * i <= upper
        invariant 0 <= i
        invariant squares == [s * s | s := 0 .. i - 1]  // sequence of squares up to i-1
        invariant forall s :: s in squares ==> lower <= s <= upper && exists k: int :: k * k == s
        invariant sorted(squares)
    {
        squares := squares + [i * i];
        i := i + 1;
    }
}

// Helper predicate to check if a number is a perfect square
predicate IsPerfectSquare(s: int)
{
    exists k: int :: k * k == s
}