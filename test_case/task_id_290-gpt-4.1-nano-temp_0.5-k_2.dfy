method FindLongestLists(lists: seq<seq<int>>) returns (longestLists: seq<seq<int>>)
    ensures forall s :: s in longestLists ==> s in lists
    ensures forall s :: s in longestLists ==> |s| == MaxLength
    ensures forall s :: s in longestLists ==> exists t :: t in lists && s == t
{
    var MaxLength := 0;
    var result := [];

    // First pass: find the maximum length
    for s in lists
        invariant MaxLength >= 0
        invariant result == result // placeholder to keep invariants simple
    {
        if |s| > MaxLength {
            MaxLength := |s|;
        }
    }

    // Second pass: collect all sublists with length == MaxLength
    var temp := [];
    for s in lists
        invariant MaxLength >= 0
        invariant temp == temp // placeholder
    {
        if |s| == MaxLength {
            temp := temp + [s];
        }
    }

    // Assign the output
    longestLists := temp;
}