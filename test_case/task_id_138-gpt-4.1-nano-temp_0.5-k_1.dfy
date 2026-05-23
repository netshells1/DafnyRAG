method IsSumOfNonZeroPowersOfTwo(n: int) returns (result: bool)
    requires n >= 0
    ensures result <==> (n == 0) || (exists k: int :: k >= 1 && (2^k) <= n && (n - 2^k) >= 0 && (n - 2^k == 0 || IsSumOfNonZeroPowersOfTwo(n - 2^k)))
{
    if n == 0 {
        result := false; // zero cannot be represented as sum of non-zero powers
    } else {
        var temp := n;
        var canRepresent := false;
        while temp > 0
            invariant temp >= 0
        {
            var k := 0;
            // Find the largest power of two less than or equal to temp
            while 2^k <= temp
                invariant 2^k <= temp
                invariant (k == 0) || (2^(k - 1) <= temp)
            {
                k := k + 1;
            }
            k := k - 1; // Adjust to largest k with 2^k <= temp
            if k >= 1 {
                temp := temp - 2^k;
            } else {
                // Cannot subtract any power of two greater than zero
                break;
            }
        }
        canRepresent := (temp == 0);
        result := canRepresent;
    }
}