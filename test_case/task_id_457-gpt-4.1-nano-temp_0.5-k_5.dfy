method MinSublistLength(s: seq<int>) returns (length: int)
    ensures length >= 0
    ensures exists start, end :: 0 <= start <= end < |s| && length == end - start + 1
    ensures forall start, end :: 0 <= start <= end < |s| ==> (end - start + 1) >= length
{
    if |s| == 0 {
        length := 0;
        return;
    }

    var minLen := |s|; // Initialize with maximum possible length
    var startIdx := 0;
    var endIdx := 0;

    // Check all sublists
    for start := 0 to |s| - 1
        invariant 0 <= start <= |s|
        invariant minLen <= |s| - start
    {
        var currentLen := 1;
        // Extend sublist from start
        for end := start to |s| - 1
            invariant start <= end < |s|
            invariant currentLen == end - start + 1
            invariant minLen <= currentLen
        {
            if currentLen < minLen {
                minLen := currentLen;
                startIdx := start;
                endIdx := end;
            }
            currentLen := currentLen + 1;
        }
    }
    length := minLen;
}