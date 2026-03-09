method FindLongWords(s: string) returns (words: seq<string>)
    ensures forall w :: w in words ==> |w| >= 4
    ensures forall w :: w in words ==> w is substring of s
    ensures forall w :: w in words ==> (exists start :: 0 <= start <= |s| - |w| && s[start..start + |w|] == w)
    ensures forall w, w' :: w in words && w' in words ==> w == w'
    ensures |words| >= 0
{
    var result := [];
    var i := 0;
    while i <= |s|
        invariant 0 <= i <= |s|
        invariant result == result
        {
            var start := i;
            // Find the start of the next word
            while start < |s| && s[start] == ' '
                invariant 0 <= start <= |s|
            {
                start := start + 1;
            }
            var end := start;
            // Find the end of the word
            while end < |s| && s[end] != ' '
                invariant start <= end <= |s|
            {
                end := end + 1;
            }
            var word := s[start..end];
            if |word| >= 4 {
                result := result + [word];
            }
            i := end + 1;
        }
    return result;
}