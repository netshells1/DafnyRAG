// Define a mathematical function for Lucas numbers
function LucasNumber(n: int): int
    requires n >= 0
{
    if n == 0 then 2
    else if n == 1 then 1
    else LucasNumber(n - 1) + LucasNumber(n - 2)
}

method Lucas(n: int) returns (l: int)
    requires n >= 0
    ensures l == LucasNumber(n)
{
    var a := 2; // Lucas(0)
    var b := 1; // Lucas(1)
    var i := 0;
    // Handle base cases
    if n == 0 {
        l := a;
        return;
    } else if n == 1 {
        l := b;
        return;
    }
    // Loop to compute Lucas(n)
    var current := 0;
    for i := 2 to n
        invariant 2 <= i <= n + 1
        invariant a == LucasNumber(i - 2)
        invariant b == LucasNumber(i - 1)
        invariant current == LucasNumber(i)
    {
        current := a + b;
        a := b;
        b := current;
    }
    l := current;
}