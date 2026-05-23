method MinListLength(lists: seq<seq<int>>) returns (minLength: int)
{
    if |lists| == 0 {
        minLength := 0;
    } else {
        minLength := |lists[0]|;
        var i := 1;
        while i < |lists|
            invariant 1 <= i <= |lists|
            invariant minLength <= |lists[i-1]| && minLength <= |lists[j]| for all j < i
        {
            if |lists[i]| < minLength {
                minLength := |lists[i]|;
            }
            i := i + 1;
        }
    }
}