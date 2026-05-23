method LucasNumber(n: int) returns (result: int)
  requires n >= 0
  ensures result == if n == 0 then 2
                   else if n == 1 then 1
                   else LucasNumber(n - 1) + LucasNumber(n - 2)
{
    if n == 0 {
        result := 2;
        return;
    } else if n == 1 {
        result := 1;
        return;
    }

    var a := 2; // Lucas number at position 0
    var b := 1; // Lucas number at position 1
    var i := 2;

    while i <= n
        invariant 2 <= i <= n + 1
        invariant a == LucasNumber(i - 2)
        invariant b == LucasNumber(i - 1)
        invariant result == b
    {
        var next := a + b;
        a := b;
        b := next;
        i := i + 1;
    }
    result := b;
}