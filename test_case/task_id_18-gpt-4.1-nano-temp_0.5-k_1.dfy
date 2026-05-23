method RemoveChars(s: string, charsToRemove: string) returns (result: string)
    ensures |result| <= |s|
    ensures forall i :: 0 <= i < |result| ==> result[i] !in charsToRemove
{
    var res := "";
    var i := 0;
    while i < |s|
        invariant 0 <= i <= |s|
        invariant |res| <= i
        invariant forall k :: 0 <= k < |res| ==> res[k] !in charsToRemove
    {
        if s[i] !in charsToRemove {
            res := res + [s[i]];
        }
        i := i + 1;
    }
    return res;
}