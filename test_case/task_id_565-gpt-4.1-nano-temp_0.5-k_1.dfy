method StringToChars(s: string) returns (chars: seq<char>)
    ensures |chars| == |s|
    ensures forall i :: 0 <= i < |s| ==> chars[i] == s[i]
{
    var result: seq<char> := [];
    var i := 0;
    while i < |s|
        invariant 0 <= i <= |s|
        invariant result == result[..i] + [s[i]]
        // The sequence result contains the characters processed so far, up to index i-1
        decreases |s| - i
    {
        result := result + [s[i]];
        i := i + 1;
    }
    return result;
}