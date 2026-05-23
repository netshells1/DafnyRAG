method CountDivisors(n: int) returns (count: int)
    requires n >= 0
    ensures count >= 0
    ensures count == |{ d: int | d > 0 && d divides n }|
{
    var c := 0;
    var i := 1;
    while i <= n
        invariant 1 <= i <= n + 1
        invariant c == |{ d: int | d > 0 && d < i && d divides n }|
    {
        if n % i == 0 {
            c := c + 1;
        }
        i := i + 1;
    }
    count := c;
}