predicate sorted(seq<int> s)
{
    forall i, j :: 0 <= i < j < |s| ==> s[i] <= s[j]
}

method FindPerfectSquaresInRange(low: int, high: int) returns (squares: seq<int>)
    requires low <= high
    ensures forall x :: x in squares ==> low <= x <= high && exists i: int :: i * i == x
    ensures forall x :: x in squares ==> low <= x <= high
    ensures sorted(squares)
{
    var result := [];
    var start := if low > 0 then ceiling(sqrt(low)) else 0;
    var end := ceiling(sqrt(high));
    var i := start;
    while i * i <= high
        invariant start <= i <= end + 1
        invariant forall x :: x in result ==> low <= x <= high && exists k: int :: k * k == x
        invariant sorted(result)
    {
        var square := i * i;
        if square >= low && square <= high {
            result := result + [square];
        }
        i := i + 1;
    }
    squares := result;
}