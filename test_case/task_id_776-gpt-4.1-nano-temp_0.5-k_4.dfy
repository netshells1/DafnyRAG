predicate IsVowel(c: char)
{
    c in ['a', 'e', 'i', 'o', 'u', 'A', 'E', 'I', 'O', 'U']
}

method CountCharsWithVowelNeighbors(s: string) returns (count: int)
    ensures count >= 0
    ensures count == | set i: int | 0 <= i < |s| && ( (i > 0 && IsVowel(s[i-1])) || (i < |s|-1 && IsVowel(s[i+1])) )
{
    var neighborChars := set i: int | 0 <= i < |s| &&
        ( (i > 0 && IsVowel(s[i-1])) || (i < |s|-1 && IsVowel(s[i+1])) );
    count := |neighborChars|;
}