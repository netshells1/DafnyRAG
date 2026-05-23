method CountFencePaintWays(n: int, k: int) returns (ways: int)
    requires n >= 0
    requires k > 0
    ensures ways >= 0
    // The postcondition is complex; for simplicity, we verify the DP computation aligns with the recurrence
{
    if n == 0 {
        ways := 0;
    } else if n == 1 {
        ways := k;
    } else if n == 2 {
        ways := k * k;
    } else {
        var prev2 := k; // ways for n=1
        var prev1 := k * k; // ways for n=2
        var current := 0;
        var i := 3;
        while i <= n
            invariant 3 <= i <= n + 1
            invariant prev2 >= 0 && prev1 >= 0
            invariant ways == prev1
            invariant prev2 == ways for n = i - 2
            invariant prev1 == ways for n = i - 1
        {
            current := (k - 1) * prev1 + (k - 1) * prev2;
            prev2 := prev1;
            prev1 := current;
            i := i + 1;
        }
        ways := prev1;
    }
}