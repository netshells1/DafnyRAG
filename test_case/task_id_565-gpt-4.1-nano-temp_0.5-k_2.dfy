method StringToChars(s: string) returns (chars: seq<char>)
    ensures chars == s[..]
{
    var result := [];
    var i := 0;
    while i < |s|
        invariant 0 <= i <= |s|
        invariant result == s[..i]
        {
            result := result + [s[i]];
            i := i + 1;
        }
    return result;
}