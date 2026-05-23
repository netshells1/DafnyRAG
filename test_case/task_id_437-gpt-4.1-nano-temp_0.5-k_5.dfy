/**
 * Remove characters at odd positions in the input string
 **/

method RemoveOddCharacters(s: string) returns (result: string)
  ensures forall i :: 0 <= i < |result| ==> result[i] in s[..] && (exists j :: 0 <= j < s.Length && j % 2 == 0 && s[j] == result[i])
{
    var resChars := [];
    var i := 0;
    while i < s.Length
      invariant 0 <= i <= s.Length
      invariant |resChars| == (i + 1) / 2
      invariant forall k :: 0 <= k < |resChars| ==> resChars[k] in s[..] && (exists j :: 0 <= j < s.Length && j % 2 == 0 && s[j] == resChars[k])
    {
        if i % 2 == 0
        {
            resChars := resChars + [s[i]];
        }
        i := i + 1;
    }
    result := String.Concat(resChars);
}