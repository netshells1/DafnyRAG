method FindTwoWordsStartingWithP(words: seq<string>) returns (word1: string, word2: string)
    requires words != null
    requires exists i, j :: 0 <= i < words.Length && 0 <= j < words.Length && i != j && words[i].Length > 0 && words[j].Length > 0 && (words[i][0] == 'p' || words[i][0] == 'P') && (words[j][0] == 'p' || words[j][0] == 'P')
    ensures exists i, j :: 0 <= i < words.Length && 0 <= j < words.Length && i != j && (words[i][0] == 'p' || words[i][0] == 'P') && (words[j][0] == 'p' || words[j][0] == 'P') && words[i] == word1 && words[j] == word2
{
    var count := 0;
    var w1 := "";
    var w2 := "";
    var found1 := false;
    var found2 := false;
    var i := 0;
    while i < words.Length && !(found1 && found2)
        invariant 0 <= i <= words.Length
        invariant (found1 && found2) ==> (w1 != "" && w2 != "")
        invariant (!found1) ==> (forall k :: 0 <= k < i ==> (words[k][0] == 'p' || words[k][0] == 'P') && words[k] == (if !found1 then w1 else w1))
        invariant (found1 && !found2) ==> (exists k :: 0 <= k < i && (words[k][0] == 'p' || words[k][0] == 'P') && words[k] == w1)
        invariant (found2) ==> (exists k :: 0 <= k < i && (words[k][0] == 'p' || words[k][0] == 'P') && words[k] == w2)
    {
        if (words[i].Length > 0 && (words[i][0] == 'p' || words[i][0] == 'P')) {
            if (!found1) {
                w1 := words[i];
                found1 := true;
            } else if (!found2 && words[i] != w1) {
                w2 := words[i];
                found2 := true;
            }
        }
        i := i + 1;
    }
    // Assign output variables
    word1 := w1;
    word2 := w2;
}