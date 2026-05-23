method IsSumOfNonZeroPowersOf2(n: int) returns (result: bool)
    requires n >= 0
    ensures result <==> (exists S: set<int> :: 
                            n == sum S && 
                            S != {} && 
                            forall x :: x in S ==> x > 0 && (x & (x - 1)) == 0)
{
    var remaining := n;
    var power := 1;
    var usedPowers := set<int>{};
    result := false;
    // We attempt to greedily subtract the largest powers of 2 from n
    while remaining > 0
        invariant remaining >= 0
        invariant usedPowers <= set<int>
        invariant forall x :: x in usedPowers ==> (x & (x - 1)) == 0 && x > 0
        invariant sum(usedPowers) == n - remaining
    {
        if remaining >= power
        {
            remaining := remaining - power;
            usedPowers := usedPowers + set{power};
        }
        power := power * 2;
        // To prevent infinite loop in case of large n, we can break if power exceeds n
        if power > n + 1
        {
            break;
        }
    }
    result := remaining == 0 && usedPowers != {};
}