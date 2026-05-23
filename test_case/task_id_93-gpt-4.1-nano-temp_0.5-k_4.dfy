method Power(a: int, b: int) returns (result: int)
    requires b >= 0
    ensures result == (if b == 0 then 1 else a ^ b)
{
    result := 1;
    var i := 0;
    while i < b
        invariant 0 <= i <= b
        invariant result == a ^ i
    {
        result := result * a;
        i := i + 1;
    }
}