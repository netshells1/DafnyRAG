Method Signature:
method LongestCommonSubsequence3(s1: string, s2: string, s3: string) returns (lcs: string)

Postconditions_prompt:
- The returned string lcs is a longest sequence that is a subsequence of s1, s2, and s3
- If there exists a longer common subsequence among s1, s2, and s3, then lcs is not that longer sequence
- The string lcs is a subsequence of each of the input strings s1, s2, and s3