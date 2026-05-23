method LongestSublistLength(lists: seq<seq<int>>) returns (maxLength: int)
    ensures maxLength >= 0
    ensures forall sub :: sub in lists ==> |sub| <= maxLength
{
    maxLength := 0;
    var i := 0;
    while i < |lists|
        invariant 0 <= i <= |lists|
        invariant maxLength >= 0
        invariant forall j :: 0 <= j < i ==> |lists[j]| <= maxLength
    {
        if |lists[i]| > maxLength {
            maxLength := |lists[i]|;
        }
        i := i + 1;
    }
}