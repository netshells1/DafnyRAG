predicate IsWhiteSpace(c: char)
{
    c == ' ' || c == '\t' || c == '\n' || c == '\r' || c == '\v' || c == '\f'
}

method RemoveWhitespaces(s: string) returns (v: string)
    ensures |v| == |{ i: int | 0 <= i < |s| && !IsWhiteSpace(s[i]) }|
    ensures forall i :: 0 <= i < |v| ==> v[i] == s[OldIndex(i, s)]
    ensures forall i :: 0 <= i < |v| ==> !IsWhiteSpace(v[i])
{
    var v' := "";
    var indexInS := 0;
    var count := 0;
    // Count the number of non-whitespace characters to determine length
    var nonWhitespaceCount := 0;
    for i := 0 to |s|
        invariant 0 <= i <= |s|
        invariant nonWhitespaceCount == |{ k: int | 0 <= k < i && !IsWhiteSpace(s[k]) }|
        {
            if i < |s| && !IsWhiteSpace(s[i]) {
                nonWhitespaceCount := nonWhitespaceCount + 1;
            }
        }
    // Build the output string with non-whitespace characters
    var result := "";
    for i := 0 to |s|
        invariant 0 <= i <= |s|
        invariant result == (if i == 0 then "" else result[0..i-1])
        invariant forall k :: 0 <= k < |result| ==> result[k] == s[OldIndex(k, s)]
        {
            if i < |s| && !IsWhiteSpace(s[i]) {
                result := result + [s[i]];
            }
        }
    return result;
}

// Helper function to find the index in s of the k-th non-whitespace character
function OldIndex(k: int, s: string): int
    requires 0 <= k < |s| && exists i :: 0 <= i < |s| && !IsWhiteSpace(s[i]) && countNonWhiteSpace(s, i) == k+1
{
    var count := 0;
    var i := 0;
    while i < |s| && count <= k
        invariant 0 <= i <= |s|
        invariant count == |{ j: int | 0 <= j < i && !IsWhiteSpace(s[j]) }|
    {
        if !IsWhiteSpace(s[i]) {
            count := count + 1;
        }
        i := i + 1;
    }
    // Since the precondition holds, i - 1 is the index of the k-th non-whitespace character
    i - 1
}

// Helper predicate to count non-whitespace characters up to position i
predicate countNonWhiteSpace(s: string, i: int)
{
    |{ j: int | 0 <= j < i && !IsWhiteSpace(s[j]) }| == countNonWhiteSpaceHelper(s, i)
}

// Helper function to count non-whitespace characters up to position i
function countNonWhiteSpaceHelper(s: string, i: int): int
{
    if i == 0 then 0
    else if !IsWhiteSpace(s[i-1]) then countNonWhiteSpaceHelper(s, i-1) + 1
    else countNonWhiteSpaceHelper(s, i-1)
}