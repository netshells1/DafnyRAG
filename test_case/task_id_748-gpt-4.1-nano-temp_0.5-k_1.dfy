predicate IsCapitalLetter(c: char)
{
    65 <= c as int <= 90
}

method InsertSpacesBeforeCapitals(s: string) returns (v: string)
    ensures |v| >= |s|
    ensures forall i :: 0 <= i < |s| ==> 
        if i == 0 then v[0] == s[0]
        else if IsCapitalLetter(s[i]) then v[i + countSpacesBefore(s, i)] == s[i]
        else v[i + countSpacesBefore(s, i)] == s[i]
{
    var v := "";
    var spaceCount := 0;
    for i := 0 to |s| - 1
        invariant 0 <= i <= |s|
        invariant v.Length == i + spaceCount
        invariant spaceCount >= 0
        // Additional invariants to track the correctness
    {
        if i > 0 && IsCapitalLetter(s[i])
        {
            v := v + " ";
            spaceCount := spaceCount + 1;
            v := v + [s[i]];
        }
        else
        {
            v := v + [s[i]];
        }
    }
    return v;
}

// Note: countSpacesBefore is a helper function to count how many spaces are inserted before position i
function countSpacesBefore(s: string, i: int): int
{
    var count := 0;
    var j := 0;
    while j < i
        invariant 0 <= j <= i
        invariant count >= 0
        // For each position before i, check if s[j] is capital and a space would be inserted before s[j+1]
        decreases j
    {
        if j > 0 && IsCapitalLetter(s[j]) then
            count := count + 1;
        j := j + 1;
    }
    count
}