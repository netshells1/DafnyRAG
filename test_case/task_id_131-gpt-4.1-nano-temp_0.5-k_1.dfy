predicate IsVowel(c: char)
{
    c in ['a', 'e', 'i', 'o', 'u', 'A', 'E', 'I', 'O', 'U']
}

function MirrorIndex(i: int, n: int): int
{
    n - 1 - i
}

method ReverseVowels(s: string) returns (v: string)
    ensures |v| == |s|
    ensures forall i :: 0 <= i < |s| ==> (IsVowel(s[i]) ==> v[i] == s[MirrorIndex(i, |s|)] && IsVowel(s[MirrorIndex(i, |s|)]))
    ensures forall i :: 0 <= i < |s| && !IsVowel(s[i]) ==> v[i] == s[i]
{
    var sArr := s.ToArray();
    var left := 0;
    var right := |sArr| - 1;
    // Create a mutable array for building the result
    var vArr := sArr;

    while left < right
        invariant 0 <= left <= right + 1
        invariant -1 <= right <= |sArr| - 1
        invariant forall i :: 0 <= i < left ==> vArr[i] == sArr[i]
        invariant forall i :: right < i < |sArr| ==> vArr[i] == sArr[i]
        invariant forall i :: left <= i <= right ==> (IsVowel(sArr[i]) ==> vArr[i] == sArr[MirrorIndex(i, |sArr|)] && IsVowel(sArr[MirrorIndex(i, |sArr|)]))
    {
        if IsVowel(sArr[left]) && IsVowel(sArr[right])
        {
            var temp := vArr[left];
            vArr[left] := vArr[right];
            vArr[right] := temp;
            left := left + 1;
            right := right - 1;
        }
        else if !IsVowel(sArr[left])
        {
            left := left + 1;
        }
        else
        {
            right := right - 1;
        }
    }
    v := new string(vArr);
}