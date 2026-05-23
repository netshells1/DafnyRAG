method ExtractRearCharacters(seq: seq<string>) returns (result: seq<char>)
    ensures |result| == |seq|
    ensures forall i :: 0 <= i < |seq| ==> (|seq[i]| > 0 ==> result[i] == seq[i][|seq[i]| - 1]) && (|seq[i]| == 0 ==> result[i] == '\0')
{
    var res := [];
    var i := 0;
    while i < |seq|
        invariant 0 <= i <= |seq|
        invariant |res| == i
        invariant forall k :: 0 <= k < i ==> (|seq[k]| > 0 ==> res[k] == seq[k][|seq[k]| - 1]) && (|seq[k]| == 0 ==> res[k] == '\0')
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