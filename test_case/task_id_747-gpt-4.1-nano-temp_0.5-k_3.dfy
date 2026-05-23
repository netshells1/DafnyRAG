method LongestCommonSubsequence3(s1: string, s2: string, s3: string) returns (lcs: string)
    ensures exists subseq1: string, subseq2: string, subseq3: string ::
             subseq1 == lcs && subseq2 == lcs && subseq3 == lcs &&
             subseq1 <= s1 && subseq2 <= s2 && subseq3 <= s3 &&
             (forall i :: 0 <= i < |lcs| ==> lcs[i] == subseq1[i]) &&
             (forall i :: 0 <= i < |lcs| ==> lcs[i] == subseq2[i]) &&
             (forall i :: 0 <= i < |lcs| ==> lcs[i] == subseq3[i]) &&
             |lcs| <= |s1| && |lcs| <= |s2| && |lcs| <= |s3|
{
    // Initialize the DP table: a 3D array to store lengths of LCS for prefixes
    var len: array[0 .. |s1|+1, 0 .. |s2|+1, 0 .. |s3|+1] := array[.., .., ..] | 0;

    // Fill the table
    var i := 0;
    while i <= |s1|
        invariant 0 <= i <= |s1|
        decreases |s1| - i
    {
        var j := 0;
        while j <= |s2|
            invariant 0 <= j <= |s2|
            decreases |s2| - j
        {
            var k := 0;
            while k <= |s3|
                invariant 0 <= k <= |s3|
                decreases |s3| - k
            {
                if i > 0 && j > 0 && k > 0 && s1[i - 1] == s2[j - 1] && s1[i - 1] == s3[k - 1] {
                    len[i, j, k] := len[i - 1, j - 1, k - 1] + 1;
                } else {
                    len[i, j, k] := max3(len[i - 1, j, k], len[i, j - 1, k], len[i, j, k - 1]);
                }
                k := k + 1;
            }
            j := j + 1;
        }
        i := i + 1;
    }

    // Reconstruct the LCS from the table
    var result := "";
    var i := |s1|;
    var j := |s2|;
    var k := |s3|;
    while i > 0 && j > 0 && k > 0
        invariant 0 <= i <= |s1|
        invariant 0 <= j <= |s2|
        invariant 0 <= k <= |s3|
        decreases i + j + k
    {
        if i > 0 && j > 0 && k > 0 && s1[i - 1] == s2[j - 1] && s1[i - 1] == s3[k - 1] && len[i, j, k] == len[i - 1, j - 1, k - 1] + 1 {
            result := s1[i - 1] + result;
            i := i - 1;
            j := j - 1;
            k := k - 1;
        } else if i > 0 && (len[i - 1, j, k] >= len[i, j, k]) {
            i := i - 1;
        } else if j > 0 && (len[i, j - 1, k] >= len[i, j, k]) {
            j := j - 1;
        } else {
            k := k - 1;
        }
    }
    lcs := result;
}

// Helper function for maximum of three integers
function max3(a: int, b: int, c: int): int
{
    if a >= b && a >= c then a
    else if b >= a && b >= c then b
    else c
}