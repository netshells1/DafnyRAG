method RemoveOddCharacters(s: string) returns (res: string)
    ensures |res| == (|s| + 1) / 2
    ensures forall i :: 0 <= i < |res| ==> exists k :: 0 <= k < |s| && 2 * k == i && s[2 * k] == res[i]
{
    var resChars: seq<char> := [];
    var i := 0;
    while 2 * i < |s|
        invariant 0 <= i <= (|s| + 1) / 2
        invariant resChars == res[..]
        invariant forall j :: 0 <= j < i ==> res[j] == s[2 * j]
    {
        resChars := resChars + [s[2 * i]];
        i := i + 1;
    }
    res := String.FromSeq(resChars);
}