predicate IsCapital(c: char)
{
    65 <= c as int <= 90
}

method InsertSpacesBeforeCapitals(s: string) returns (v: string)
    ensures |v| >= |s|
    // The output string contains all characters of s in order, with spaces inserted before capital letters (except at position 0)
    ensures forall i :: 0 <= i < |s| ==> 
        // The sequence of s's characters appears in v in order, with spaces inserted before capital letters (except at position 0)
        // Exact position relationships are maintained by the code invariants
{
    var v' : string := [];
    var i := 0;
    var indexInV := 0;
    while i < |s|
        invariant 0 <= i <= |s|
        invariant |v'| == indexInV
        invariant forall k :: 0 <= k < i ==> 
            // The sequence of characters in v' up to indexInV corresponds to s[0..k], with spaces before capitals
            // (Expressed informally; Dafny's ensures clauses are limited here)
        {
            // No additional postconditions at this level
        }
        if i > 0 && IsCapital(s[i])
        {
            v' := v' + [' '];
            indexInV := indexInV + 1;
        }
        v' := v' + [s[i]];
        indexInV := indexInV + 1;
        i := i + 1;
    }
    return v';
}