method FindPerfectSquaresInRange(start: int, end: int) returns (squares: seq<int>)
    requires start <= end
    requires start >= 0
    ensures forall x :: x in squares ==> start <= x <= end && exists i: int :: i * i == x
    ensures sorted(squares)
{
    var result := [];
    var i := 0;
    // Find the smallest i such that i * i >= start
    while i * i < start
        invariant 0 <= i
        invariant i * i < start ==> i * i >= start
        invariant result == []
    {
        i := i + 1;
    }
    // Collect all perfect squares between start and end
    while i * i <= end
        invariant 0 <= i
        invariant result == [j * j | j := 0 .. i - 1]
        invariant forall j :: 0 <= j < |result| ==> result[j] == j * j
        invariant result == [j * j | j := 0 .. i - 1]
    {
        result := result + [i * i];
        i := i + 1;
    }
    squares := result;
}