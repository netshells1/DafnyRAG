method FindWordsStartingWithP(words: seq<string>) returns (word1: string, word2: string)
    requires |words| >= 2
    requires words != null
    ensures (exists i :: 0 <= i < |words| && (words[i][0] == 'p' || words[i][0] == 'P') && words[i] == word1)
    ensures (exists j :: 0 <= j < |words| && (words[j][0] == 'p' || words[j][0] == 'P') && words[j] == word2 && j > i)
    ensures forall k :: 0 <= k < |words| && (words[k][0] == 'p' || words[k][0] == 'P') ==> (k == i || k == j))
{
    var found1 := false;
    var found2 := false;
    var idx1 := 0;
    var idx2 := 0;
    word1 := "";
    word2 := "";

    var i := 0;
    while i < |words| && !(found1 && found2)
        invariant 0 <= i <= |words|
        invariant (exists i1 :: 0 <= i1 < i && (words[i1][0] == 'p' || words[i1][0] == 'P') && word1 == words[i1]) || !found1
        invariant (exists i2 :: 0 <= i2 < i && (words[i2][0] == 'p' || words[i2][0] == 'P') && word2 == words[i2]) || !found2
        invariant (found1 ==> word1 == words[idx1])
        invariant (found2 ==> word2 == words[idx2])
    {
        if |words[i]| > 0 && (words[i][0] == 'p' || words[i][0] == 'P') {
            if !found1 {
                word1 := words[i];
                idx1 := i;
                found1 := true;
            } else if !found2 && i != idx1 {
                word2 := words[i];
                idx2 := i;
                found2 := true;
            }
        }
        i := i + 1;
    }
}