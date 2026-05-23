predicate IsVowel(c: char)
{
    c in {'a', 'e', 'i', 'o', 'u', 'A', 'E', 'I', 'O', 'U'}
}

method CountVowelNeighbors(s: string) returns (count: int)
    requires s != null
    ensures count >= 0
    ensures count == |{ i: int | 0 < i < |s| && (IsVowel(s[i-1]) || IsVowel(s[i+1])) }|
{
    count := 0;
    var n := |s|;
    var i := 0;
    while i < n
        invariant 0 <= i <= n
        invariant count >= 0
        invariant count == |{ j: int | 0 < j < i && (IsVowel(s[j-1]) || IsVowel(s[j+1])) }|
    {
        if 0 < i < n {
            if IsVowel(s[i-1]) || IsVowel(s[i+1]) {
                count := count + 1;
            }
        }
        i := i + 1;
    }
}