Method Signature:
method LongestCommonSubsequence3(s1: string, s2: string, s3: string) returns (lcs: seq<char>)

Postconditions_prompt:
- The returned sequence lcs is a subsequence of s1, s2, and s3
- The length of lcs is the maximum possible length of a common subsequence among the three input strings
- If there exists a longer common subsequence, it is not returned by this method