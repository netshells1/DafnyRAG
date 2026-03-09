method FindLongWords(s: string) returns (words: seq<string>)
    ensures forall w :: w in words ==> |w| >= 4
    ensures forall w :: w in words ==> exists start, end :: 0 <= start <= end <= |s| && s[start..end] == w
    ensures forall i :: 0 <= i < |words| ==> (s[StartIndex(words[i])..EndIndex(words[i])] == words[i])
{
    var result := [];
    var startIdx := 0;
    var inWord := false;

    // Helper functions to find start and end indices of each word
    function method StartIndex(w: string): nat
        reads this
        {
            var index := 0;
            var currentPos := 0;
            while currentPos <= |s| - |w|
                invariant 0 <= index <= |s|
                invariant 0 <= currentPos <= |s|
                decreases |s| - currentPos
            {
                if s[currentPos..currentPos + |w|] == w
                {
                    return currentPos;
                }
                currentPos := currentPos + 1;
            }
            // Should not reach here if w is in s
            return 0;
        }

    function method EndIndex(w: string): nat
        reads this
        {
            var start := StartIndex(w);
            return start + |w|;
        }

    var i := 0;
    while i <= |s|
        invariant 0 <= i <= |s|
        invariant result == [w | w in result]
        decreases |s| - i
    {
        // Skip non-letter characters
        if i < |s| && s[i..i+1] == ""
        {
            i := i + 1;
            continue;
        }
        // Find start of a word
        var wordStart := i;
        while i < |s| && s[i..i+1] != " "
            invariant wordStart <= i <= |s|
            invariant 0 <= wordStart <= |s|
            decreases |s| - i
        {
            i := i + 1;
        }
        var wordEnd := i;
        var length := wordEnd - wordStart;
        if length >= 4
        {
            var w := s[wordStart..wordEnd];
            result := result + [w];
        }
        // Skip spaces
        while i < |s| && s[i..i+1] == " "
            invariant i <= |s|
            invariant 0 <= i <= |s|
            decreases |s| - i
        {
            i := i + 1;
        }
    }
    return result;
}