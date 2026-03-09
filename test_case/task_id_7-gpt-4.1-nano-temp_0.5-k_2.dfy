method FindLongWords(s: string) returns (words: seq<string>)
    ensures forall w :: w in words ==> |w| >= 4
    ensures forall w' :: w' in SplitIntoWords(s) ==> exists w :: w in words && w == w'
{
    var result := [];
    var currentWord := "";
    for i := 0 to |s|
        invariant 0 <= i <= |s|
        invariant currentWord == (if 0 <= i < |s| then
                                        if s[i] != ' ' then currentWord + [s[i]] else ""
                                    else currentWord)
        invariant result == [w | w in SplitIntoWords(s) && |w| >= 4]
    {
        if i < |s| && s[i] != ' ' {
            currentWord := currentWord + [s[i]];
        } else {
            if |currentWord| >= 4 {
                result := result + [currentWord];
            }
            currentWord := "";
        }
    }
    // Handle last word if string ends without space
    if |currentWord| >= 4 {
        result := result + [currentWord];
    }
    words := result;
}

// Helper function to split string into words based on spaces
function SplitIntoWords(str: string): seq<string>
{
    var words := [];
    var current := "";
    for c in str
        invariant true
    {
        if c != ' ' {
            current := current + [c];
        } else {
            if |current| > 0 {
                words := words + [current];
                current := "";
            }
        }
    }
    if |current| > 0 {
        words := words + [current];
    }
    return words;
}