predicate IsVowel(c: char)
{
    c == 'a' || c == 'e' || c == 'i' || c == 'o' || c == 'u' ||
    c == 'A' || c == 'E' || c == 'I' || c == 'O' || c == 'U'
}

method CountCharsWithVowelNeighbors(s: string) returns (count: int)
    ensures count >= 0
    ensures count == |{ i: int | 0 < i < |s| && IsVowel(s[i-1]) && IsVowel(s[i+1]) }|
{
    count := 0;
    var i := 1;
    while i < |s| - 1
        invariant 1 <= i <= |s|
        invariant count == |{ j: int | 1 <= j < i && IsVowel(s[j-1]) && IsVowel(s[j+1]) }|
    {
        if IsVowel(s[i-1]) && IsVowel(s[i+1]) {
            count := count + 1;
        }
        i := i + 1;
    }
}