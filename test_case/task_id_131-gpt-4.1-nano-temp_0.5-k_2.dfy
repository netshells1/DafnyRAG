predicate IsVowel(c: char)
{
    c == 'a' || c == 'e' || c == 'i' || c == 'o' || c == 'u' ||
    c == 'A' || c == 'E' || c == 'I' || c == 'O' || c == 'U'
}

method ReverseVowels(s: string) returns (v: string)
    ensures |v| == |s|
    ensures forall i :: 0 <= i < |s| ==> (IsVowel(s[i]) ==> v[i] == s[revIndex(i, s)])
    ensures forall i :: 0 <= i < |s| && !IsVowel(s[i]) ==> v[i] == s[i]
{
    var vowels := [char];
    // Collect vowels in order
    var i := 0;
    while i < |s|
        invariant 0 <= i <= |s|
        invariant |vowels| <= |s|
        {
            if IsVowel(s[i]) {
                vowels := vowels + [s[i]];
            }
            i := i + 1;
        }
    var revVowels := vowels[..][|vowels| - 1 .. 0 .. -1]; // reversed vowels
    var vChars := s[..];
    var vArr := vChars[..]; // create mutable array of characters
    var vowelIdx := 0;
    i := 0;
    while i < |s|
        invariant 0 <= i <= |s|
        invariant 0 <= vowelIdx <= |vowels|
        invariant vArr[..] == s[..]
        {
            if IsVowel(s[i]) {
                vArr[i] := revVowels[vowelIdx];
                vowelIdx := vowelIdx + 1;
            }
            i := i + 1;
        }
    v := vArr[..];
}

// Helper function to get the index of the vowel in the reversed list
function revIndex(i: int, s: string): int
{
    // The position of s[i] among vowels in s
    var count := 0;
    var j := 0;
    while j <= i
        invariant 0 <= j <= i
        invariant count >= 0
        {
            if IsVowel(s[j]) {
                count := count + 1;
            }
            j := j + 1;
        }
    // The index in reversed list is total vowels minus count
    var totalVowels := |[c: char | c in s[..] && IsVowel(c)]|;
    totalVowels - count
}