predicate ValidWordChar(c: char)
{
    // Define valid characters for words (e.g., letters)
    (97 <= c as int <= 122) || (65 <= c as int <= 90)
}

function WordSequence(str: string): seq<string>
{
    var words := [];
    var i := 0;
    while i < |str|
        invariant 0 <= i <= |str|
        invariant words != null
        {
            // Skip non-word characters
            while i < |str| && !ValidWordChar(str[i])
                invariant 0 <= i <= |str|
            {
                i := i + 1;
            }
            // Collect word characters
            var start := i;
            while i < |str| && ValidWordChar(str[i])
                invariant start <= i <= |str|
            {
                i := i + 1;
            }
            if start < i
                invariant start >= 0 && i <= |str|
            {
                var word := str[start..i];
                words := words + [word];
            }
        }
    words
}

function ReverseWordSequence(seq: seq<string>): seq<string>
{
    if |seq| == 0 then []
    else ReverseWordSequence(seq[1..]) + [seq[0]]
}

method ReverseWords(s: string) returns (result: string)
    ensures |result| == |s|
    ensures WordSequence(result) == ReverseWordSequence(WordSequence(s))
{
    var words := WordSequence(s);
    var revWords := ReverseWordSequence(words);
    var res := "";
    var first := true;
    for w in revWords
        invariant res != null
        invariant forall prev: string :: prev in revWords[..|revWords|-1] ==> res[0..prev.Length] == prev
    {
        if first {
            res := w;
            first := false;
        } else {
            res := res + " " + w;
        }
    }
    return res;
}