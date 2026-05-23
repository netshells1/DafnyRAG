predicate IsVowel(c: char)
{
    c == 'a' || c == 'e' || c == 'i' || c == 'o' || c == 'u' ||
    c == 'A' || c == 'E' || c == 'I' || c == 'O' || c == 'U'
}

method CountVowelNeighbors(s: string) returns (count: int)
    ensures count >= 0
    ensures count == | { i: int | 1 <= i < |s| - 1 && IsVowel(s[i - 1]) && IsVowel(s[i + 1]) } |
{
    count := 0;
    var n := |s|;
    var i := 1;
    while i < n - 1
        invariant 1 <= i <= n - 1
        invariant count >= 0
        // The count increases by 1 for each position i where s[i] has vowel neighbors
        invariant count == |{ k: int | 1 <= k < i && IsVowel(s[k - 1]) && IsVowel(s[k + 1]) }|
    {
        if IsVowel(s[i - 1]) && IsVowel(s[i + 1]) {
            count := count + 1;
        }
        i := i + 1;
    }
}