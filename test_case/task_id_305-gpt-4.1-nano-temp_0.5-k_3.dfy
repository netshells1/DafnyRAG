method FindWordsStartingWithP(words: seq<string>) returns (word1: string, word2: string)
    ensures (exists i :: 0 <= i < |words| && (words[i][0] == 'p' || words[i][0] == 'P')) ==> (word1 == words[0]) || (word2 == words[1])
    ensures (forall i :: 0 <= i < |words| && (words[i][0] == 'p' || words[i][0] == 'P')) ==> (word1 == words[i]) || (word2 == words[i])
    ensures (|matchingWords| < 2) ==> (word1 == "") && (word2 == "")
    ensures (|matchingWords| >= 2) ==> (word1 in first two matching words) && (word2 in first two matching words)
{
    var count := 0;
    var firstMatch := "";
    var secondMatch := "";
    var matchCount := 0;
    var foundWords: seq<string> := [];
    var i := 0;
    while i < |words|
        invariant 0 <= i <= |words|
        invariant matchCount <= 2
        invariant |foundWords| == matchCount
        invariant matchCount <= 2
        invariant forall j :: 0 <= j < i ==> 
            (words[j][0] == 'p' || words[j][0] == 'P') ==> true
        {
        if |words[i]| > 0 && (words[i][0] == 'p' || words[i][0] == 'P') {
            if matchCount == 0 {
                firstMatch := words[i];
                matchCount := 1;
                foundWords := [words[i]];
            } else if matchCount == 1 {
                secondMatch := words[i];
                matchCount := 2;
                foundWords := foundWords + [words[i]];
            }
        }
        i := i + 1;
    }
    if matchCount >= 2 {
        word1 := firstMatch;
        word2 := secondMatch;
    } else {
        word1 := "";
        word2 := "";
    }
}