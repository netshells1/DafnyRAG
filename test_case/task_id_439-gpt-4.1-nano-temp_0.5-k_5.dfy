function concatIntegers(a: array<int>): int
  requires a != null
{
    var res := 0;
    var i := 0;
    while i < a.Length
        invariant 0 <= i <= a.Length
        invariant res >= 0
        invariant res == fold concatDigits(a[0..i])
        decreases a.Length - i
    {
        res := concatDigits(res, a[i]);
        i := i + 1;
    }
    res
}

function method concatDigits(x: int, y: int): int
{
    if y == 0 then x
    else
        var digits := 1;
        var temp := y;
        while temp > 0
            invariant 1 <= digits
            invariant temp >= 0
            decreases temp
        {
            temp := temp / 10;
            digits := digits * 10;
        }
        x * digits + y
}

method JoinArray(a: array<int>) returns (result: int)
    requires a != null
    ensures result == concatIntegers(a)
{
    result := concatIntegers(a);
}