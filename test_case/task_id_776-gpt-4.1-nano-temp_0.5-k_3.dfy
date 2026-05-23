predicate IsVowel(c: char)
{
    c in {'a', 'e', 'i', 'o', 'u', 'A', 'E', 'I', 'O', 'U'}
}

method CountVowelsNeighbors(s: string) returns (count: int)
    ensures count >= 0
    ensures count == | set i: int | 0 < i < |s| && (IsVowel(s[i-1]) || IsVowel(s[i+1])) |
{
    count := 0;
    for i := 0 to |s|
        invariant 0 <= i <= |s|
        invariant 0 <= count <= |s|
        // We only check for neighbors if i is not at the boundary
        if 0 < i < |s| {
            if IsVowel(s[i-1]) || IsVowel(s[i+1]) {
                count := count + 1;
            }
        }
    }
}