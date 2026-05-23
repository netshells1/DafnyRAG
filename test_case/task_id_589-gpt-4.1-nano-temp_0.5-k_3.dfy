method FindPerfectSquaresInRange(lower: int, upper: int) returns (result: seq<int>)
    requires lower <= upper
    ensures forall x :: x in result ==> lower <= x <= upper && exists i: int :: i * i == x
    ensures forall i, j :: 0 <= i < j < |result| ==> result[i] < result[j]
{
    var res := [];
    var start := 0;
    // Find the smallest integer whose square >= lower
    var i := 0;
    while i * i < lower
        invariant 0 <= i
        invariant i * i < lower ==> i + 1 <= upper // optional, for tighter bounds
        invariant res == []
    {
        i := i + 1;
    }
    // Collect all perfect squares >= lower and <= upper
    while i * i <= upper
        invariant 0 <= i
        invariant res == [ for x in res :: exists k: int :: k * k == x ]
        invariant forall x :: x in res ==> lower <= x <= upper && exists k: int :: k * k == x
        invariant (i - 1) * (i - 1) < lower ==> i * i >= lower
    {
        res := res + [i * i];
        i := i + 1;
    }
    result := res;
}