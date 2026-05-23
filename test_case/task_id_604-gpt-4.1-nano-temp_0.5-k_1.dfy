predicate IsSpace(c: char)
{
    c == ' '
}

function Words(s: string): seq<string>
{
    var result := [];
    var start := 0;
    var i := 0;
    while i < |s|
        invariant 0 <= start <= i <= |s|
        invariant result == if start == i then result else result + [s[start..i]]
        invariant forall j :: start <= j < i ==> s[j] != ' '
        decreases |s| - i
    {
        if IsSpace(s[i]) {
            if start < i {
                result := result + [s[start..i]];
            }
            start := i + 1;
        }
        i := i + 1;
    }
    if start < |s| {
        result := result + [s[start..|s|]];
    }
    result
}

function Concatenate(words: seq<string>): string
{
    if |words| == 0 then "" else words[0] + (if |words| > 1 then " " + Concatenate(words[1..]) else "")
}

method ReverseWords(s: string) returns (v: string)
    ensures |v| == |s|
    ensures Words(v) == Reverse(Words(s))
    ensures v == Concatenate(Words(v))
{
    var wordSeq := Words(s);
    var revWords := wordSeq[..];
    revWords := revWords[..];
    // Reverse the sequence of words
    var i := 0;
    var j := |revWords| - 1;
    while i < j
        invariant 0 <= i <= j + 1
        invariant 0 <= j < |revWords|
        invariant revWords[..i] == Reverse(revWords[j+1..])
        decreases j - i
    {
        var temp := revWords[i];
        revWords := revWords[0..i] + [revWords[j]] + revWords[i+1..j] + [temp] + revWords[j+1..];
        i := i + 1;
        j := j - 1;
    }
    v := Concatenate(revWords);
}