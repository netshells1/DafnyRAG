predicate IsReverse(s1: string, s2: string)
{
    |s1| == |s2| && forall i :: 0 <= i < |s1| ==> s1[i] == s2[|s2| - 1 - i]
}

method ReverseString(s: string) returns (rev: string)
    ensures IsReverse(s, rev)
{
    var res := "";
    var i := 0;
    while i < |s|
        invariant 0 <= i <= |s|
        invariant res == s[..i].Reverse
        decreases |s| - i
    {
        res := s[i] + res;
        i := i + 1;
    }
    return res;
}

method ReverseStringsInList(lst: list<string>) returns (reversedList: list<string>)
    ensures |reversedList| == |lst|
    ensures forall i :: 0 <= i < |lst| ==> reversedList[i] == ReverseString(lst[i])
{
    reversedList := [];
    var i := 0;
    while i < |lst|
        invariant 0 <= i <= |lst|
        invariant |reversedList| == i
        invariant forall j :: 0 <= j < i ==> reversedList[j] == ReverseString(lst[j])
    {
        var revStr := ReverseString(lst[i]);
        reversedList := reversedList + [revStr];
        i := i + 1;
    }
}