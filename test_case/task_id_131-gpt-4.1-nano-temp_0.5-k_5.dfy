predicate IsVowel(c: char)
{
    c in ['a', 'e', 'i', 'o', 'u', 'A', 'E', 'I', 'O', 'U']
}

method ReverseVowels(s: string) returns (v: string)
    ensures |v| == |s|
    ensures forall i :: 0 <= i < |s| && IsVowel(s[i]) ==> v[i] == s[revVowels[i]]
    ensures forall i :: 0 <= i < |s| && !IsVowel(s[i]) ==> v[i] == s[i]
{
    var sChars := s.ToSeq();
    var vowelIndices := [];
    var vowels := [];

    // Collect all vowel positions and vowels
    for i := 0 to |sChars|
        invariant 0 <= i <= |sChars|
        invariant |vowelIndices| == |vowels|
        {
            if IsVowel(sChars[i]) {
                vowelIndices := vowelIndices + [i];
                vowels := vowels + [sChars[i]];
            }
        }

    // Reverse the vowels
    var reversedVowels := vowels[..];
    reversedVowels := reversedVowels[..];

    // Build the output string
    var resultChars := sChars;

    var revIdx := |reversedVowels| - 1;

    for idx in 0 .. |vowelIndices|
        invariant 0 <= idx <= |vowelIndices|
        {
            var pos := vowelIndices[idx];
            resultChars := resultChars[0 .. pos] + [reversedVowels[revIdx]] + resultChars[pos + 1 ..];
            revIdx := revIdx - 1;
        }

    v := resultChars.ToString();
}