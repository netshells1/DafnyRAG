predicate IsVowel(c: char)
{
    c in ['a', 'e', 'i', 'o', 'u', 'A', 'E', 'I', 'O', 'U']
}

function ReverseIndex(s: string, i: int): int
{
    (|s| - 1) - i
}

method ReverseVowels(s: string) returns (v: string)
    ensures |v| == |s|
    ensures forall i :: 0 <= i < |s| ==> (IsVowel(s[i]) ==> v[i] == s[ReverseIndex(s, i)]) && (!IsVowel(s[i]) ==> v[i] == s[i])
{
    var sArr := s.ToArray;
    var left := 0;
    var right := |sArr| - 1;
    while left < right
        invariant 0 <= left <= right + 1
        invariant 0 <= right < |sArr|
        invariant forall k :: 0 <= k < left ==> sArr[k] == s[k]
        invariant forall k :: right < k < |sArr| ==> sArr[k] == s[k]
        invariant forall k :: left <= k <= right ==> sArr[k] == s[k]
    {
        if IsVowel(sArr[left]) && IsVowel(sArr[right])
        {
            var temp := sArr[left];
            sArr[left] := sArr[right];
            sArr[right] := temp;
            left := left + 1;
            right := right - 1;
        }
        else if !IsVowel(sArr[left])
        {
            left := left + 1;
        }
        else if !IsVowel(sArr[right])
        {
            right := right - 1;
        }
        else
        {
            // Should not reach here
        }
    }
    v := new string(sArr);
}