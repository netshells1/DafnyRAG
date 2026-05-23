predicate IsSpace(c: char)
{
    c == ' '
}

function method SplitWords(s: string): seq<string>
{
    var words := [];
    var current := "";
    for c in s
        invariant true
    {
        if IsSpace(c)
        {
            if current != ""
            {
                words := words + [current];
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
        words := words + [current];
    }
    return words;
}

function method JoinWords(words: seq<string>): string
{
    if |words| == 0 then ""
    else
        var s := words[0];
        for i := 1 to |words|-1
            invariant 1 <= i <= |words|
            invariant s == (if i == 1 then words[0] else s)
        {
            s := s + " " + words[i];
        }
        s
}

function method ReverseWordList(words: seq<string>): seq<string>
{
    if |words| <= 1 then
        words
    else
        ReverseWordList(words[|words|-1..|words|]) + words[0..|words|-1]
}

method ReverseWords(s: string) returns (result: string)
    ensures |result| == |s|
    ensures result == JoinWords(ReverseWordList(SplitWords(s)))
{
    var words := SplitWords(s);
    var revWords := ReverseWordList(words);
    result := JoinWords(revWords);
}