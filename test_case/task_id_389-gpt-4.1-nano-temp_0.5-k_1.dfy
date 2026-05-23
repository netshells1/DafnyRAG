method LucasNumber(n: int) returns (ln: int)
  requires n >= 0
  ensures ln == if n == 0 then 2
                 else if n == 1 then 1
                 else for all k :: 0 <= k <= n ==> LucasSequence(k)
{
    // Helper function for Lucas sequence
    function LucasSequence(k: int): int
        requires 0 <= k
    {
        if k == 0 then 2
        else if k == 1 then 1
        else LucasSequence(k - 1) + LucasSequence(k - 2)
    }

    var a := 2; // Lucas(0)
    var b := 1; // Lucas(1)
    var i := 0;
    ln := 0;

    if n == 0 {
        ln := 2;
        return;
    } else if n == 1 {
        ln := 1;
        return;
    }

    for i := 2 to n
        invariant 2 <= i <= n + 1
        invariant a == LucasSequence(i - 2)
        invariant b == LucasSequence(i - 1)
        invariant ln == LucasSequence(i)
    {
        var next := a + b;
        a := b;
        b := next;
    }
    ln := b;
}