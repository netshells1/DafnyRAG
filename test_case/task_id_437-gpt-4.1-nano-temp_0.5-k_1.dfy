method RemoveOddCharacters(s: string) returns (result: string)
    ensures |result| == ((|s| + 1) / 2)
    ensures forall i :: 0 <= i < |result| ==> s[2 * i] == result[i]
{
    var res := "";
    var i := 0;
    while 2 * i < |s|
        invariant 0 <= i <= |s| / 2
        invariant |res| == i
        invariant forall k :: 0 <= k < i ==> s[2 * k] == res[k]
    {
        res := res + [s[2 * i]];
        i := i + 1;
    }
    return res;
}