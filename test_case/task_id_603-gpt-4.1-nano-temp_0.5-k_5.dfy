method GetLucidNumbers(n: int) returns (result: seq<int>)
    requires n >= 0
    ensures forall x :: x in result ==> 1 <= x <= n && IsLucid(x)
    ensures forall x :: x in result, y :: y in result && x < y ==> x < y
    ensures |result| >= 0
{
    var res := [];
    var x := 1;
    while x <= n
        invariant 0 <= x <= n+1
        invariant res == [k | k := 1 .. x-1, IsLucid(k)]
        invariant forall k :: 1 <= k < x ==> IsLucid(k)
    {
        if IsLucid(x) {
            res := res + [x];
        }
        x := x + 1;
    }
    result := res;
}

// Helper function to determine if a number is lucid
function IsLucid(x: int): bool
{
    // Placeholder: define the condition for lucid numbers
    // For demonstration, assume lucid numbers are perfect squares
    var sqrt_x := sqrt(x);
    sqrt_x * sqrt_x == x
}