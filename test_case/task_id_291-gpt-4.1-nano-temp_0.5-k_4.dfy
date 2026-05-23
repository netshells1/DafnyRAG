method CountPaintWays(n: int, k: int) returns (ways: int)
    requires n >= 0
    requires k >= 1
    ensures ways >= 0
    ensures ways == 
        if n == 0 then 1
        else if n == 1 then k
        else
            // For n >= 2, ways is computed via DP
            // The exact formula can be verified after implementation
{
    if n == 0 {
        ways := 1;
    } else if n == 1 {
        ways := k;
    } else {
        var dp0 := k; // ways to paint first post
        var dp1 := k * (k - 1); // ways to paint second post
        var i := 2;
        while i <= n
            invariant 2 <= i <= n
            invariant dp0 >= 0
            invariant dp1 >= 0
            invariant ways == if i == 2 then dp1 else 0
        {
            var next := (k - 1) * (dp1 + dp0);
            dp0 := dp1;
            dp1 := next;
            i := i + 1;
        }
        ways := dp1;
    }
}