method FirstWithSmallestSecond(s: seq<seq<int>>) returns (result: int)
    requires |s| > 0
    requires forall seq :: seq in s ==> |seq| >= 2
    ensures exists i :: 0 <= i < s.Length && s[i].Length >= 2 && s[i][1] == minSecond && s[i][0] == result
    ensures forall i :: 0 <= i < s.Length && s[i].Length >= 2 && s[i][1] == minSecond ==> s[i][0] >= result
{
    var minSecond := if |s| > 0 then s[0][1] else 0;
    var minSeqIndex := 0;

    // Initialize minSecond and minSeqIndex
    for i := 1 to s.Length
        invariant 1 <= i <= s.Length
        invariant 0 <= minSeqIndex < i
        invariant minSecond == if |s| > 0 then s[minSeqIndex][1] else 0
        invariant forall k :: 0 <= k < i && |s[k]| >= 2 ==> s[k][1] >= minSecond
    {
        if |s[i]| >= 2 && s[i][1] < minSecond {
            minSecond := s[i][1];
            minSeqIndex := i;
        }
    }

    result := s[minSeqIndex][0];
}