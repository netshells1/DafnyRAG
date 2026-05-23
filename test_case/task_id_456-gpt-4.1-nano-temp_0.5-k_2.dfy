predicate True // placeholder, no special predicates needed

function ReverseString(s: string): string
{
    var rev := "";
    var i := 0;
    while i < |s|
        invariant 0 <= i <= |s|
        invariant rev == s[..i].Reverse()
    {
        rev := s[i] + rev;
        i := i + 1;
    }
    rev
}

method ReverseStrings(lst: seq<string>) returns (result: seq<string>)
    ensures |result| == |lst|
    ensures forall i :: 0 <= i < |lst| ==> result[i] == ReverseString(lst[i])
{
    var res := [];
    var i := 0;
    while i < |lst|
        invariant 0 <= i <= |lst|
        invariant |res| == i
        invariant forall j :: 0 <= j < i ==> res[j] == ReverseString(lst[j])
    {
        res := res + [ReverseString(lst[i])];
        i := i + 1;
    }
    return res;
}