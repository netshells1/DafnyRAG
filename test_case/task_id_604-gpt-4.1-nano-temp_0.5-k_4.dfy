predicate IsSpace(c: char)
{
    c == ' '
}

function Words(s: string): seq<string>
{
    if |s| == 0 then
        []
    else
        var start := 0;
        var res := [];
        var i := 0;
        while i < |s|
            invariant 0 <= start <= i <= |s|
            invariant res == if start == i then [] else [s[start..i]]
            {
                if IsSpace(s[i])
                {
                    if start < i
                        then res := res + [s[start..i]];
                    start := i + 1;
                }
                i := i + 1;
            }
        if start < |s|
            then res := res + [s[start..|s>]]
        res
}

method ReverseWords(s: string) returns (result: string)
    ensures |result| == |s|
    ensures Words(result) == Reverse(Words(s))
    ensures forall i :: 0 <= i < |Words(s)| ==> result.Contains(Words(s)[i])
{
    var words := Words(s);
    var revWords := Reverse(words);
    var resSeq := "";
    var firstWord := true;
    for w in revWords
        invariant true
        {
            if firstWord
            {
                resSeq := w;
                firstWord := false;
            }
            else
            {
                resSeq := resSeq + " " + w;
            }
        }
    result := resSeq;
}