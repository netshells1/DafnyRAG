method FindLongWords(s: string) returns (words: seq<string>)
    ensures forall w :: w in words ==> |w| >= 4
    ensures forall w :: w in words ==> exists start, end :: 0 <= start <= end <= |s| && s[start..end] == w && (start == 0 || s[start - 1] == ' ') && (end == |s| || s[end] == ' ')
{
    var result := [];
    var startIdx := 0;
    var i := 0;
    while i <= |s|
        invariant 0 <= startIdx <= i
        invariant result == result[..]
    {
        if i == |s| || s[i] == ' ' {
            if i - startIdx >= 4 {
                var word := s[startIdx .. i];
                result := result + [word];
            }
            startIdx := i + 1;
        }
        i := i + 1;
    }
    words := result;
}