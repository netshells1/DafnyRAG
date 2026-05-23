method LucasNumber(n: int) returns (l: int)
  requires n >= 0
  ensures l == if n == 0 then 2 else if n == 1 then 1 else
            // For n ≥ 2, l equals the nth Lucas number
            // Since this is a postcondition, we can state:
            // l == Lucas(n), where Lucas(n) is the sequence defined as above
            // Alternatively, specify the sequence explicitly:
            // l == 2 if n == 0
            // l == 1 if n == 1
            // otherwise l == Lucas(n-1) + Lucas(n-2)
{
    var prev1 := 2; // Lucas(0)
    var prev2 := 1; // Lucas(1)
    if n == 0 {
        l := 2;
        return;
    } else if n == 1 {
        l := 1;
        return;
    }
    var i := 2;
    while i <= n
        invariant 2 <= i <= n + 1
        invariant l == prev1 + prev2
        invariant prev1 == Lucas(i - 2)
        invariant prev2 == Lucas(i - 1)
    {
        l := prev1 + prev2;
        prev1 := prev2;
        prev2 := l;
        i := i + 1;
    }
}