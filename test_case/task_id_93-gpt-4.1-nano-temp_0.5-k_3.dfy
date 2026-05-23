method Power(a: int, b: nat) returns (result: int)
  requires b >= 0
  ensures result == if b == 0 then 1 else a * Power(a, b - 1)
{
    var res := 1;
    var i := 0;
    while i < b
        invariant 0 <= i <= b
        invariant res == a.pow(i)
    {
        res := res * a;
        i := i + 1;
    }
    result := res;
}

// Auxiliary function to define power recursively for verification purposes
function pow(x: int, y: nat): int
    decreases y
{
    if y == 0 then 1 else x * pow(x, y - 1)
}