method SmallestListLength(lists: seq<seq<int>>) returns (length: int)
    requires |lists| > 0
    ensures length >= 0
    ensures exists i :: 0 <= i < |lists| && length == |lists[i]|
    ensures forall i :: 0 <= i < |lists| ==> length <= |lists[i]|
{
    length := |lists[0]|;
    var i := 1;
    while i < |lists|
        invariant 1 <= i <= |lists|
        invariant length >= 0
        invariant exists j :: 0 <= j < i && length == |lists[j]|
        invariant forall j :: 0 <= j < i ==> length <= |lists[j]|
    {
        if |lists[i]| < length {
            length := |lists[i|;
        }
        i := i + 1;
    }
}