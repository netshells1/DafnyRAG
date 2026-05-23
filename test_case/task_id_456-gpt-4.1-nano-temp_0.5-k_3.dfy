predicate IsString(c: char)
{
    // All characters are valid; for simplicity, assume all chars are valid.
    true
}

function method Reverse(s: string): string
{
    if |s| == 0 then ""
    else Reverse(s[1..]) + [s[0]]
}

method ReverseStrings(strs: seq<string>) returns (res: seq<string>)
    ensures |res| == |strs|
    ensures forall i :: 0 <= i < |strs| ==> res[i] == Reverse(strs[i])
{
    var resultSeq: seq<string> := [];
    var i := 0;
    while i < |strs|
        invariant 0 <= i <= |strs|
        invariant |resultSeq| == i
        invariant forall j :: 0 <= j < i ==> resultSeq[j] == Reverse(strs[j])
    {
        resultSeq := resultSeq + [Reverse(strs[i])];
        i := i + 1;
    }
    return resultSeq;
}