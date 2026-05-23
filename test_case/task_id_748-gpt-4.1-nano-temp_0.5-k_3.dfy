predicate IsCapitalLetter(c: char)
{
    65 <= c as int <= 90
}

method InsertSpacesBeforeCapitals(s: string) returns (v: string)
    ensures |v| >= |s|
    ensures forall i :: 0 <= i < |v| ==> 
        (if i > 0 && v[i] == ' ' then i - 1 < |s| && IsCapitalLetter(s[i - 1]) else true)
{
    var vBuilder := "";
    var i := 0;
    while i < |s|
        invariant 0 <= i <= |s|
        invariant |vBuilder| >= 0
        invariant forall k :: 0 <= k < |vBuilder| ==> true // placeholder for more detailed invariants if needed
    {
        if i > 0 && IsCapitalLetter(s[i])
        {
            vBuilder := vBuilder + " " + s[i];
        }
        else
        {
            vBuilder := vBuilder + s[i];
        }
        i := i + 1;
    }
    return v := vBuilder;
}