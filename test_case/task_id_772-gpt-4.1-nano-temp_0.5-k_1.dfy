method RemoveWordsOfLengthK(s: string, k: int) returns (result: string)
    requires k >= 0
    ensures result == StringJoin(FilterWords(s, k))
{
    var words := SplitIntoWords(s);
    var filteredWords := [];
    var i := 0;
    while i < |words|
        invariant 0 <= i <= |words|
        invariant filteredWords == [w | j := 0..i-1 :: w == words[j] && |w| != k]
        {
            if |words[i]| != k {
                filteredWords := filteredWords + [words[i]];
            }
            i := i + 1;
        }
    result := StringJoin(filteredWords);
}

// Helper function to split string into words separated by spaces
function method SplitIntoWords(s: string): seq<string>
{
    // Implementation: split s by spaces
    // Since Dafny does not have built-in split, we simulate with a recursive function or sequence comprehension
    // For simplicity, assume a function exists or implement inline
    // Here, we provide an inline implementation for splitting
    var result := [];
    var current := "";
    for c in s
        invariant true
    {
        if c == ' '
        {
            if current != ""
            {
                result := result + [current];
                current := "";
            }
        }
        else
        {
            current := current + [c];
        }
    }
    if current != ""
    {
        result := result + [current];
    }
    return result;
}

// Helper function to join words into a string separated by spaces
function method StringJoin(words: seq<string>): string
{
    if |words| == 0 then ""
    else
        var s := "";
        for i := 0 to |words|-1
            invariant 0 <= i <= |words|
            invariant s == (if i == 0 then "" else StringJoin(words[0..i]))
        {
            if i == 0
            {
                s := words[0];
            }
            else
            {
                s := s + " " + words[i];
            }
        }
        s
}