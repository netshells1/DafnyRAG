method ExtractRearCharacters(seqStrings: seq<string>) returns (rearChars: seq<char>)
  ensures |rearChars| == |seqStrings|
  ensures forall i :: 0 <= i < |seqStrings| ==> 
            (if |seqStrings[i]| > 0 then rearChars[i] == seqStrings[i][|seqStrings[i]| - 1]
             else rearChars[i] == '\0')
{
    var result := [];
    var i := 0;
    while i < |seqStrings|
      invariant 0 <= i <= |seqStrings|
      invariant |result| == i
      invariant forall k :: 0 <= k < i ==> 
                  (if |seqStrings[k]| > 0 then result[k] == seqStrings[k][|seqStrings[k]| - 1]
                   else result[k] == '\0')
    {
        if |seqStrings[i]| > 0 {
            result := result + [seqStrings[i][|seqStrings[i]| - 1]];
        } else {
            result := result + ['\0'];
        }
        i := i + 1;
    }
    rearChars := result;
}