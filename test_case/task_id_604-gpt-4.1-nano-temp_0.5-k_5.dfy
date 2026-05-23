predicate WordsInReverseOrder(s: string, r: string)
{
    var sWords := s.Split(' ');
    var rWords := r.Split(' ');
    sWords.Length == rWords.Length &&
    forall i :: 0 <= i < sWords.Length ==> sWords[i] == rWords[rWords.Length - 1 - i]
}

method ReverseWords(s: string) returns (result: string)
    ensures |result| == |s|
    ensures WordsInReverseOrder(s, result)
{
    var words := s.Split(' ');
    var reversedWords := new string[words.Length];
    var i := 0;
    while i < words.Length
        invariant 0 <= i <= words.Length
        invariant forall j :: 0 <= j < i ==> reversedWords[j] == words[words.Length - 1 - j]
        invariant forall j :: i <= j < words.Length ==> reversedWords[j] == ""
    {
        reversedWords[words.Length - 1 - i] := words[i];
        i := i + 1;
    }
    var resultStr := "";
    var j := 0;
    while j < reversedWords.Length
        invariant 0 <= j <= reversedWords.Length
        invariant forall k :: 0 <= k < j ==> resultStr == (if k == 0 then "" else resultStr.Substring(0, resultStr.Length - 1)) + " " + reversedWords[k]
    {
        if j == 0
            then resultStr := reversedWords[j]
            else resultStr := resultStr + " " + reversedWords[j];
        j := j + 1;
    }
    return resultStr;
}