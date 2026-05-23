method FindShortestSublistContaining(lst: seq<int>, v: int) returns (start: int, length: int)
    ensures (start == -1 && length == 0) <==> (v !in lst)
    ensures v in lst ==> 0 <= start < |lst| && 1 <= length <= |lst| - start && lst[start..start+length] contains v
    ensures v in lst ==> forall s, e :: 0 <= s < start && s + 1 <= e <= start + length - 1 ==> v !in lst[s..e]
{
    start := -1;
    length := 0;
    var minLen := |lst| + 1;
    var minStart := -1;
    var i := 0;
    while i < |lst|
        invariant 0 <= i <= |lst|
        invariant start == -1 || (0 <= start < |lst| && 1 <= length <= |lst| - start && lst[start..start+length] contains v)
        invariant (start != -1) ==> (forall s :: 0 <= s < start || s >= start + length ==> lst[s] != v)
        decreases |lst| - i
    {
        if lst[i] == v {
            // find the shortest sublist ending at or containing i
            var j := i;
            // expand backwards to find earliest occurrence
            var startIdx := i;
            while startIdx >= 0 && lst[startIdx] != v
                invariant 0 <= startIdx <= i
                invariant forall s :: startIdx+1 <= s <= i ==> lst[s] != v
                decreases startIdx
            {
                if lst[startIdx] == v {
                    break;
                }
                startIdx := startIdx - 1;
            }
            var currentLen := i - startIdx + 1;
            if currentLen < minLen {
                minLen := currentLen;
                minStart := startIdx;
            }
        }
        i := i + 1;
    }
    if minStart != -1 {
        start := minStart;
        length := minLen;
    } else {
        start := -1;
        length := 0;
    }
}