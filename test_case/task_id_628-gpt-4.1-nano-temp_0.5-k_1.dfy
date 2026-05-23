predicate CharIsSpace(c: char)
{
    c == ' '
}

method ReplaceSpaces(s: string) returns (v: string)
    ensures v.Length == s.Length + 2 * (|s| - |s| where s[i] != ' ')
    ensures forall i :: 0 <= i < s.Length ==> 
             (s[i] == ' ' ==> v[?]) // Spaces are replaced by '%20'
{
    var vBuilder : seq<char> := [];
    var i := 0;
    while i < s.Length
        invariant 0 <= i <= s.Length
        invariant vBuilder.Length == i + CountSpacesInPrefix(s, i)
    {
        if CharIsSpace(s[i]) {
            vBuilder := vBuilder + ['%', '2', '0'];
        } else {
            vBuilder := vBuilder + [s[i]];
        }
        i := i + 1;
    }
    v := SeqToString(vBuilder);
}

function CountSpacesInPrefix(s: string, endIndex: int): nat
    decreases endIndex
{
    if endIndex == 0 then 0
    else
        (if s[endIndex - 1] == ' ' then 1 else 0) + CountSpacesInPrefix(s, endIndex - 1)
}

function SeqToString(seq: seq<char>): string
{
    var s: string := "";
    for c in seq
        s := s + [c];
    s
}