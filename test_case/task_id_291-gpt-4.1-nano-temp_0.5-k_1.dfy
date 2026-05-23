method CountFencePaintings(n: int, k: int) returns (ways: int)
    requires n >= 0
    requires k >= 1
    ensures ways == if n == 0 then 1
                   else if n == 1 then k
                   else (k * (k - 1) + k) * (k - 1)^(n - 2)
{
    if n == 0 {
        ways := 1;
    } else if n == 1 {
        ways := k;
    } else {
        var same := k; // number of ways where last two posts have same color
        var diff := k * (k - 1); // number of ways where last two posts have different colors
        var total := same + diff;
        var i := 3;
        while i <= n
            invariant 3 <= i <= n + 1
            invariant total == (k * (k - 1) + k) * (k - 1)^(i - 2)
        {
            var newSame := diff;
            var newDiff := total * (k - 1);
            total := newSame + newDiff;
            i := i + 1;
        }
        ways := total;
    }
}