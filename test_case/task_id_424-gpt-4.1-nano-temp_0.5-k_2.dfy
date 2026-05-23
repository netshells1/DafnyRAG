method ExtractRearCharacters(seq: seq<string>) returns (result: seq<char>)
    requires seq != null
    ensures |result| == |seq|
    ensures forall i :: 0 <= i < |seq| ==> result[i] == (if |seq[i]| > 0 then seq[i][|seq[i]| - 1] else '\0')
{
    var res := [];
    var i := 0;
    while i < |seq|
        invariant 0 <= i <= |seq|
        invariant |res| == i
        invariant forall k :: 0 <= k < i ==> res[k] == (if |seq[k]| > 0 then seq[k][|seq[k]| - 1] else '\0')
    {
        if |seq[i]| > 0 {
            res := res + [seq[i][|seq[i]| - 1]];
        } else {
            res := res + ['\0'];
        }
        i := i + 1;
    }
    return res;
}