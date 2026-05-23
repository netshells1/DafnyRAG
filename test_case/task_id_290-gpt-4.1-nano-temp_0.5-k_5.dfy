method MaxLengthList(lists: seq<seq<int>>) returns (maxList: seq<int>)
    ensures maxList in lists || (|lists| == 0 && maxList == [])
    ensures |maxList| == if |lists| == 0 then 0 else max i |lists[i]|
    ensures forall i :: 0 <= i < |lists| ==> |lists[i]| <= |maxList|
{
    var maxLen := 0;
    var result := [];

    // Loop over each list to find the maximum length list
    var i := 0;
    while i < |lists|
        invariant 0 <= i <= |lists|
        invariant forall j :: 0 <= j < i ==> |lists[j]| <= maxLen
        invariant |result| <= maxLen
        invariant maxLen >= 0
    {
        if |lists[i]| > maxLen {
            maxLen := |lists[i]|;
            result := lists[i];
        }
        i := i + 1;
    }
    maxList := result;
}