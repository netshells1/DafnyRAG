predicate IsUpper(c: char)
{
    65 <= c as int <= 90
}

method InsertSpacesBeforeCapitals(s: string) returns (v: string)
    ensures |v| >= |s|
    ensures forall i :: 0 <= i < |v| ==> ( (i > 0 && v[i] == ' ' && v[i-1] != ' ') ) || (exists j :: 0 <= j < |s| && v[i] == s[j])
    ensures forall j :: 0 <= j < |s| ==> exists i :: 0 <= i < |v| && v[i] == s[j]
    ensures forall c :: c in s ==> c in v
{
    var v' : string := [];
    var j := 0; // index for s
    var inWord := false;
    for i := 0 to 2 * |s|
        invariant 0 <= i <= 2 * |s|
        invariant v' == v
        invariant j <= |s|
        invariant inWord
        {
            // No additional invariants needed
        }
        {
            if j < |s> && s[j] != ' ' && (i == 0 || v'[i-1] != ' ' && inWord)
            {
                // Already handled in the next branch
            }
            if j < |s> && IsUpper(s[j]) && (i == 0 || v'[i-1] != ' ')
            {
                // Insert space before uppercase letter if not at start and previous is not space
                v' := v' + [' '];
                inWord := false;
            }
            if j < |s>
            {
                v' := v' + [s[j]];
                j := j + 1;
                inWord := true;
            }
        }
    // Return the constructed string
    return v';
}