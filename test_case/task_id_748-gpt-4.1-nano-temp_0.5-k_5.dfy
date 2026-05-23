predicate IsCapitalLetter(c: char)
{
    65 <= c as int <= 90
}

method InsertSpacesBeforeCapitals(s: string) returns (v: string)
    ensures |v| >= |s|
    ensures forall i :: 0 <= i < |s| && IsCapitalLetter(s[i]) && i > 0 ==> 
                exists j :: 0 <= j < |v| && v[j] == ' ' && v[j+1] == s[i]
    ensures forall i :: 0 <= i < |s| ==> 
                if IsCapitalLetter(s[i]) && i > 0 then v[PositionInV(s, i)] == s[i] else v[PositionInV(s, i)] == s[i]
{
    var v := "";
    var indexV := 0;
    var i := 0;
    while i < |s|
        invariant 0 <= i <= |s|
        invariant |v| == indexV
        invariant forall k :: 0 <= k < i ==> v[PositionInV(s, k)] == s[k] || (IsCapitalLetter(s[k]) && k > 0 && v[PositionInV(s, k)] == ' ')
    {
        if i > 0 && IsCapitalLetter(s[i])
        {
            v := v + " ";
            indexV := indexV + 1;
            v := v + s[i];
            indexV := indexV + 1;
        }
        else
        {
            v := v + s[i];
            indexV := indexV + 1;
        }
        i := i + 1;
    }
    return v;
}

// Helper function to find position of character in v corresponding to s[i]
function PositionInV(s: string, i: int): int
{
    // Since we insert a space before capital letters (except possibly the first), the position in v is:
    // number of capital letters before position i (excluding first position) + i
    var count := 0;
    var j := 0;
    while j < i
        invariant 0 <= j <= i
        invariant count <= j
        invariant forall k :: 0 <= k < j && IsCapitalLetter(s[k]) && k > 0 ==> 
            PositionInV(s, k) == k + (k - 1) // each capital letter after first adds a space
    {
        if j > 0 && IsCapitalLetter(s[j])
        {
            count := count + 1;
        }
        j := j + 1;
    }
    // position in v:
    return i + count;
}