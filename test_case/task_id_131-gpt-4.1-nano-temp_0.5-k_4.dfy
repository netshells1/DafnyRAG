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
    ensures forall i :: 0 <= i < |s| ==> (IsVowel(s[i]) ==> v[i] == s[MirrorIndex(i, |s|)]) && (!IsVowel(s[i]) ==> v[i] == s[i])
{
    var sArr := s.ToArray();
    var left := 0;
    var right := |sArr| - 1;
    var vArr := sArr;

    while left < right
        invariant 0 <= left <= right + 1
        invariant 0 <= right < |sArr|
        invariant forall k :: 0 <= k < left ==> vArr[k] == sArr[k]
        invariant forall k :: right < k < |sArr| ==> vArr[k] == sArr[k]
        invariant forall k :: left <= k <= right ==> (IsVowel(sArr[k]) ==> vArr[k] == sArr[MirrorIndex(k, |sArr)]) && (!IsVowel(sArr[k]) ==> vArr[k] == sArr[k])
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