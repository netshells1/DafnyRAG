method FindWordsStartingWithP(words: seq<string>) returns (word1: string, word2: string)
    requires exists w1, w2 :: w1 in words && w2 in words && w1 != w2 && w1[0] == 'p' && w2[0] == 'p'
    requires |words| >= 2
    ensures word1 in words && word2 in words
    ensures word1[0] == 'p' && word2[0] == 'p'
    ensures word1 == _w1
    ensures word2 == _w2
{
    var found1 := false;
    var found2 := false;
    var w1: string := "";
    var w2: string := "";

    var i := 0;
    while i < |words| && !(found1 && found2)
        invariant 0 <= i <= |words|
        invariant (exists w :: w in seq[..i] && w[0] == 'p') ==> (found1 || found2)
        invariant (forall k :: 0 <= k < i ==> (words[k][0] == 'p') ==> (words[k] == w1 || words[k] == w2))
        invariant (found1 ==> w1 in seq[..i])
        invariant (found2 ==> w2 in seq[..i])
        invariant (found1 && found2) ==> (w1 != w2)
    {
        if |words[k]| > 0 && words[k][0] == 'p' && !found1 {
            w1 := words[k];
            found1 := true;
        } else if |words[k]| > 0 && words[k][0] == 'p' && found1 && !found2 && words[k] != w1 {
            w2 := words[k];
            found2 := true;
        }
        i := i + 1;
    }
    // Assign output
    word1 := w1;
    word2 := w2;
}