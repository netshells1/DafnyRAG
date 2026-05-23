method FindLongestLists(lists: seq<seq<int>>) returns (longestLists: seq<seq<int>>)
    ensures |lists| == 0 ==> |longestLists| == 0
    ensures |lists| > 0 ==> forall l :: l in longestLists ==> l in lists
    ensures |lists| > 0 ==> forall l :: l in longestLists ==> |l| == MaxLength
{
    var maxLen := 0;
    // First pass: find the maximum length
    var i := 0;
    while i < |lists|
        invariant 0 <= i <= |lists|
        invariant maxLen >= 0
        invariant forall j :: 0 <= j < i ==> |lists[j]| <= maxLen
    {
        if |lists[i]| > maxLen {
            maxLen := |lists[i]|;
        }
        i := i + 1;
    }
    // Handle empty input
    if |lists| == 0 {
        return [];
    }
    // Second pass: collect all lists with length == maxLen
    var result := [];
    var j := 0;
    while j < |lists|
        invariant 0 <= j <= |lists|
        invariant result[..] == [l | l in result]
        invariant forall k :: 0 <= k < j ==> |lists[k]| <= maxLen
        invariant result.All(l => |l| == maxLen)
    {
        if |lists[j]| == maxLen {
            result := result + [lists[j]];
        }
        j := j + 1;
    }
    return result;
}

function MaxLength(lists: seq<seq<int>>) : int
    ensures MaxLength == if |lists| == 0 then 0 else |lists[0]|
{
    var maxLen := 0;
    var i := 0;
    while i < |lists|
        invariant 0 <= i <= |lists|
        invariant maxLen >= 0
        invariant forall j :: 0 <= j < i ==> |lists[j]| <= maxLen
    {
        if |lists[i]| > maxLen {
            maxLen := |lists[i]|;
        }
        i := i + 1;
    }
    maxLen
}