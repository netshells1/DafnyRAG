method FindLongWords(s: string) returns (words: seq<string>)
    ensures forall w :: w in words ==> |w| >= 4
    ensures forall w :: w in words ==> (exists start :: 0 <= start <= |s| - |w| && s[start .. start + |w|] == w)
{
    var result := [];
    var start := 0;
    var length := |s|;
    var inWord := false;
    var wordStart := 0;

    // Iterate through the string to identify words separated by spaces or punctuation
    for i := 0 to length
        invariant 0 <= i <= length
        invariant result == result
    {
        if i < length && s[i] != ' ' && s[i] != ',' && s[i] != '.' && s[i] != '!' && s[i] != '?' && s[i] != ';' && s[i] != ':' && s[i] != '-' && s[i] != '\n' && s[i] != '\r' && s[i] != '\t'
        {
            if !inWord
            {
                inWord := true;
                wordStart := i;
            }
        }
        else
        {
            if inWord
            {
                inWord := false;
                var wordLen := i - wordStart;
                if wordLen >= 4
                {
                    var w := s[wordStart .. i];
                    result := result + [w];
                }
            }
        }
    }
    // Handle last word if string ends with a word
    if inWord
    {
        var wordLen := length - wordStart;
        if wordLen >= 4
        {
            var w := s[wordStart .. length];
            result := result + [w];
        }
    }
    return result;
}