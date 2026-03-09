method RemoveFirstAndLastOccurrence(s: string, ch: char) returns (v: string)
    requires s != null
    ensures
        (exists i :: 0 <= i < |s| && s[i] == ch) ==> v == RemoveCharsAtIndices(s, [FirstOccurrence(s, ch), LastOccurrence(s, ch)])
        && (forall i :: 0 <= i < |s| ==> s[i] != ch) ==> v == s
{
    var firstIdx := FirstOccurrence(s, ch);
    var lastIdx := LastOccurrence(s, ch);

    if firstIdx == -1 || lastIdx == -1 || firstIdx >= lastIdx {
        // ch does not occur or occurs only once; return s unchanged
        v := s;
    } else {
        v := RemoveCharsAtIndices(s, [firstIdx, lastIdx]);
    }
}

// Helper function to find the first occurrence index of ch in s
function FirstOccurrence(s: string, ch: char): int
    ensures (exists i :: 0 <= i < |s| && s[i] == ch) ==> 0 <= result < |s| && s[result] == ch
    ensures (forall i :: 0 <= i < |s| && s[i] == ch ==> i >= result)
{
    var i := 0;
    while i < |s| && s[i] != ch
        invariant 0 <= i <= |s|
    {
        i := i + 1;
    }
    if i == |s| then
        -1
    else
        i
}

// Helper function to find the last occurrence index of ch in s
function LastOccurrence(s: string, ch: char): int
    ensures (exists i :: 0 <= i < |s| && s[i] == ch) ==> 0 <= result < |s| && s[result] == ch
    ensures (forall i :: 0 <= i < |s| && s[i] == ch ==> i <= result)
{
    var i := |s| - 1;
    while i >= 0 && s[i] != ch
        invariant -1 <= i < |s|
    {
        i := i - 1;
    }
    if i < 0 then
        -1
    else
        i
}

// Helper function to remove characters at specified indices from s
function RemoveCharsAtIndices(s: string, indices: seq<int>): string
    ensures forall i :: 0 <= i < |s| ==> (i !in indices) ==> s[i] == result[i - countSmaller(indices, i)]
    ensures |result| == |s| - |indices|
{
    var result := "";
    var idxSet := set indices;
    var count := 0;
    for i := 0 to |s| - 1
        invariant 0 <= i <= |s|
        invariant result.Length == i - count
    {
        if i in idxSet {
            count := count + 1;
        } else {
            result := result + [s[i]];
        }
    }
    result
}

// Helper function to count how many indices in 'indices' are less than 'i'
function countSmaller(indices: seq<int>, i: int): int
{
    |{k: int | k in indices && k < i}|
}