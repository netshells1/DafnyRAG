method MaxLengthList(lists: seq<seq<int>>) returns (maxList: seq<int>)
    requires lists != null
{
    if |lists| == 0 {
        maxList := [];
        return;
    }
    var maxLen := 0;
    maxList := lists[0];
    var i := 1;
    while i < |lists|
        invariant 1 <= i <= |lists|
        invariant |maxList| >= 0
        invariant maxLen >= 0
        invariant (exists j :: 0 <= j < i && |lists[j]| == maxLen)
        invariant (forall j :: 0 <= j < i ==> |lists[j]| <= maxLen)
    {
        if |lists[i]| > |maxList| {
            maxList := lists[i];
            maxLen := |lists[i]|;
        }
        i := i + 1;
    }
}