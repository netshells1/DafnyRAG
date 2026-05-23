method LongestCommonSubsequence3(s1: string, s2: string, s3: string) returns (lcs: string)
    ensures forall i :: 0 <= i < |lcs| ==> exists k1, k2, k3 :: 0 <= k1 < |s1| && 0 <= k2 < |s2| && 0 <= k3 < |s3| && k1 < k2 < k3 && s1[k1] == s2[k2] == s3[k3] && lcs[i] == s1[k1]
    ensures |lcs| >= 0
    ensures forall k1, k2, k3 :: 0 <= k1 < |s1| && 0 <= k2 < |s2| && 0 <= k3 < |s3| && k1 < k2 < k3 && s1[k1] == s2[k2] == s3[k3] ==> exists i :: 0 <= i < |lcs| && lcs[i] == s1[k1]
{
    // Initialize DP table: 3D array for storing lengths
    var dp: array[array[array]int]] := new array[|s1| + 1];
    for i := 0 to |s1| {
        dp[i] := new array[|s2| + 1];
        for j := 0 to |s2| {
            dp[i][j] := new array[int](|s3| + 1);
        }
    }

    // Fill DP table
    for i := 0 to |s1| {
        for j := 0 to |s2| {
            for k := 0 to |s3| {
                if i == 0 || j == 0 || k == 0 {
                    dp[i][j][k] := 0;
                } else if s1[i - 1] == s2[j - 1] && s2[j - 1] == s3[k - 1] {
                    dp[i][j][k] := 1 + dp[i - 1][j - 1][k - 1];
                } else {
                    dp[i][j][k] := max(dp[i - 1][j][k], dp[i][j - 1][k], dp[i][j][k - 1]);
                }
            }
        }
    }

    // Reconstruct LCS from DP table
    var res := "";
    var i := |s1|;
    var j := |s2|;
    var k := |s3|;
    while i > 0 && j > 0 && k > 0
        invariant 0 <= i <= |s1|
        invariant 0 <= j <= |s2|
        invariant 0 <= k <= |s3|
        invariant res == s[lcs]
        decreases i + j + k
    {
        if s1[i - 1] == s2[j - 1] && s2[j - 1] == s3[k - 1] {
            res := s1[i - 1] + res;
            i := i - 1;
            j := j - 1;
            k := k - 1;
        } else if dp[i - 1][j][k] >= dp[i][j - 1][k] && dp[i - 1][j][k] >= dp[i][j][k - 1] {
            i := i - 1;
        } else if dp[i][j - 1][k] >= dp[i][j][k - 1] {
            j := j - 1;
        } else {
            k := k - 1;
        }
    }
    return res;
}