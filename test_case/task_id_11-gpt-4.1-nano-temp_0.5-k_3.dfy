method RemoveFirstAndLastOccurrence(s: string, c: char) returns (v: string)
    ensures (exists i :: 0 <= i < |s| && s[i] == c) ==> (|v| == |s| - 2 && 
        (forall k :: 0 <= k < |v| ==> 
            (k < firstIndex || k > lastIndex - 2) ==> v[k] == s[if k < firstIndex then k else k + 2]))
    ensures (forall i :: 0 <= i < |s| ==> s[i] != c) ==> v == s
{
    var firstIndex := -1;
    var lastIndex := -1;
    var i := 0;
    // Find first occurrence of c
    while i < |s|
        invariant 0 <= i <= |s|
        invariant firstIndex >= -1
        invariant lastIndex >= -1
        invariant (firstIndex >= 0) ==> (forall j :: 0 <= j < firstIndex ==> s[j] != c)
        invariant (lastIndex >= 0) ==> (forall j :: lastIndex < j < |s| ==> s[j] != c)
    {
        if s[i] == c && firstIndex == -1 {
            firstIndex := i;
        }
        if s[|s| - 1 - i] == c && lastIndex == -1 {
            lastIndex := |s| - 1 - i;
        }
        i := i + 1;
    }
    if firstIndex == -1 || lastIndex == -1 || firstIndex >= lastIndex {
        // No or only one occurrence, return s unchanged
        v := s;
    } else {
        v := "";
        var idx := 0;
        // Copy characters before first occurrence
        while idx < firstIndex
            invariant 0 <= idx <= firstIndex
            invariant v.Length == idx
        {
            v := v + [s[idx]];
            idx := idx + 1;
        }
        // Skip first occurrence at firstIndex
        // Copy characters between firstIndex+1 and lastIndex-1
        var j := firstIndex + 1;
        while j < lastIndex
            invariant firstIndex + 1 <= j <= lastIndex
            invariant v.Length == idx + (j - (firstIndex + 1))
        {
            v := v + [s[j]];
            j := j + 1;
        }
        // Skip last occurrence at lastIndex
        // Copy remaining characters after lastIndex
        var k := lastIndex + 1;
        while k < |s|
            invariant lastIndex + 1 <= k <= |s|
            invariant v.Length == idx + (lastIndex - firstIndex - 1) + (k - (lastIndex + 1))
        {
            v := v + [s[k]];
            k := k + 1;
        }
    }
}