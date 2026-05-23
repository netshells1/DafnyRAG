predicate IsLowerCase(c: char)
{
    97 <= c as int <= 122
}

method ContainsUnderscoreLowercaseSequence(s: string) returns (result: bool)
    ensures result <==> (exists start, mid, end :: 
        0 <= start < |s| && 0 <= mid < |s| && 0 <= end <= |s| &&
        start < mid && mid < end &&
        // substring before underscore: all lowercase
        (forall i :: start <= i < mid ==> IsLowerCase(s[i])) &&
        // underscore at mid
        s[mid] == '_' &&
        // substring after underscore: all lowercase
        (forall i :: mid+1 <= i < end ==> IsLowerCase(s[i])) &&
        // no other underscores in the segments
        (forall i :: start <= i < mid ==> s[i] != '_') &&
        (forall i :: mid+1 <= i < end ==> s[i] != '_'))
{
    result := false;
    var i := 0;
    while i < |s|
        invariant 0 <= i <= |s|
        invariant result <==> (exists start, mid, end :: 
            0 <= start < |s| && 0 <= mid < |s| && 0 <= end <= |s| &&
            start < mid && mid < end &&
            // substring before underscore: all lowercase
            (forall k :: start <= k < mid ==> IsLowerCase(s[k])) &&
            // underscore at mid
            s[mid] == '_' &&
            // substring after underscore: all lowercase
            (forall k :: mid+1 <= k < end ==> IsLowerCase(s[k])) &&
            // no other underscores in the segments
            (forall k :: start <= k < mid ==> s[k] != '_') &&
            (forall k :: mid+1 <= k < end ==> s[k] != '_') &&
            // positions before i do not violate the pattern
            (forall k :: 0 <= k < i ==> 
                // no underscore before mid in processed part
                (k < mid ==> s[k] != '_') &&
                // no underscore after mid in processed part
                (k >= mid ==> s[k] != '_') &&
                // lowercase in segments before mid
                (k < mid ==> IsLowerCase(s[k])) &&
                // lowercase in segments after mid
                (k >= mid ==> IsLowerCase(s[k]))
            )
        );
        if exists start, mid, end :: 
            0 <= start < |s| && 0 <= mid < |s| && 0 <= end <= |s| &&
            start < mid && mid < end &&
            (forall k :: start <= k < mid ==> IsLowerCase(s[k])) &&
            s[mid] == '_' &&
            (forall k :: mid+1 <= k < end ==> IsLowerCase(s[k])) &&
            (forall k :: start <= k < mid ==> s[k] != '_') &&
            (forall k :: mid+1 <= k < end ==> s[k] != '_') &&
            k >= i
        {
            // pattern found
            result := true;
            break;
        }
        i := i + 1;
    }
}