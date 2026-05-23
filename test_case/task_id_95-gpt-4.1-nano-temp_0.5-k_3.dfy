method MinListLength(lists: seq<seq<int>>) returns (minLen: int)
    ensures minLen >= 0
    ensures exists i :: 0 <= i < |lists| && |lists[i]| == minLen
{
    if |lists| == 0 {
        minLen := 0;
    } else {
        minLen := |lists[0]|;
        var i := 1;
        while i < |lists|
            invariant 1 <= i <= |lists|
            invariant minLen <= |lists[i-1]|
            invariant exists j :: 0 <= j < i && |lists[j]| == minLen
        {
            if |lists[i]| < minLen {
                minLen := |lists[i]|;
            }
            i := i + 1;
        }
    }
}