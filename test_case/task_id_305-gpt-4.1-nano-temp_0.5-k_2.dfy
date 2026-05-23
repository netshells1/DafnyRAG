method GetWordsStartingWithP(words: seq<string>) returns (result: seq<string>)
    ensures |result| == 2
    ensures forall w :: w in result ==> (|w| > 0 && (w[0] == 'p' || w[0] == 'P'))
    ensures forall w :: w in result ==> w in words
{
    var res := [];
    var count := 0;
    var i := 0;
    while i < |words| && count < 2
        invariant 0 <= i <= |words|
        invariant |res| == count
        invariant forall j :: 0 <= j < |res| ==> res[j] in words && (|res[j]| > 0 && (res[j][0] == 'p' || res[j][0] == 'P'))
        invariant count <= 2
    {
        if |res| < 2 && (|words[i]| > 0 && (words[i][0] == 'p' || words[i][0] == 'P')) {
            res := res + [words[i]];
            count := count + 1;
        }
        i := i + 1;
    }
    result := res;
}