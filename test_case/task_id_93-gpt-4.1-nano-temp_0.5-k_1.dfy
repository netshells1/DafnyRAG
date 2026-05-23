method Power(a: int, b: int) returns (result: int)
    requires b >= 0
    ensures result == if b == 0 then 1 else a * Power(a, b - 1)
{
    if b == 0 {
        result := 1;
    } else {
        var temp := Power(a, b - 1);
        result := a * temp;
    }
}