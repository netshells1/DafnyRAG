method LongestCommonSubsequence3(s1: string, s2: string, s3: string) returns (lcs: string)
    ensures forall i :: 0 <= i < |lcs| ==> exists k1, k2, k3 :: 0 <= k1 < |s1| && 0 <= k2 < |s2| && 0 <= k3 < |s3| &&
            s1[k1] == s2[k2] == s3[k3] && lcs[i] == s1[k1]
    ensures subsequence(lcs, s1)
    ensures subsequence(lcs, s2)
    ensures subsequence(lcs, s3)
{
    var m := |s1|;
    var n := |s2|;
    var o := |s3|;
    var dp: array<array<array<int>>> := new array[m+1, n+1, o+1];

    // Initialize the DP array
    for i := 0 to m
        invariant 0 <= i <= m
        {
            for j := 0 to n
                invariant 0 <= j <= n
                {
                    for k := 0 to o
                        invariant 0 <= k <= o
                        {
                            if i == 0 || j == 0 || k == 0 {
                                dp[i,j,k] := 0;
                            }
                        }
                }
        }

    // Fill the DP array
    for i := 1 to m
        invariant 0 <= i <= m
        decreases i
        {
            for j := 1 to n
                invariant 0 <= j <= n
                decreases j
                {
                    for k := 1 to o
                        invariant 0 <= k <= o
                        decreases k
                        {
                            if s1[i-1] == s2[j-1] && s1[i-1] == s3[k-1] {
                                dp[i,j,k] := dp[i-1,j-1,k-1] + 1;
                            } else {
                                dp[i,j,k] := max3(dp[i-1,j,k], dp[i,j-1,k], dp[i,j,k-1]);
                            }
                        }
                }
        }

    // Reconstruct the LCS from the DP array
    var i := m;
    var j := n;
    var k := o;
    var lcsChars := [];
    while i > 0 && j > 0 && k > 0
        invariant 0 <= i <= m
        invariant 0 <= j <= n
        invariant 0 <= k <= o
        invariant subsequence(lcs, s1)
        invariant subsequence(lcs, s2)
        invariant subsequence(lcs, s3)
        decreases i + j + k
    {
        if s1[i-1] == s2[j-1] && s1[i-1] == s3[k-1] {
            lcsChars := [s1[i-1]] + lcsChars;
            i := i - 1;
            j := j - 1;
            k := k - 1;
        } else if dp[i-1,j,k] >= dp[i,j-1,k] && dp[i-1,j,k] >= dp[i,j,k-1] {
            i := i - 1;
        } else if dp[i,j-1,k] >= dp[i-1,j,k] && dp[i,j-1,k] >= dp[i,j,k-1] {
            j := j - 1;
        } else {
            k := k - 1;
        }
    }
    lcs := String(lcsChars);
}
  
// Helper function to get maximum of three integers
function max3(a: int, b: int, c: int): int
{
    if a >= b && a >= c then a
    else if b >= a && b >= c then b
    else c
}