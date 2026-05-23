predicate IsLowercaseLetter(c: char)
{
    97 <= c as int <= 122
}

method ContainsUnderscoreLowercaseSequence(s: string) returns (result: bool)
    ensures result <==> (exists start, end :: 0 <= start < end <= |s| &&
        start > 0 && end < |s| &&
        (forall i :: start <= i < end ==> IsLowercaseLetter(s[i])) &&
        s[start - 1] == '_' &&
        (forall i :: end <= i < |s| ==> IsLowercaseLetter(s[i])))
{
    result := false;
    var i := 0;
    while i < |s|
        invariant 0 <= i <= |s|
        invariant result ==> (exists start, end :: 0 <= start < end <= i &&
            start > 0 && end <= i &&
            (forall k :: start <= k < end ==> IsLowercaseLetter(s[k])) &&
            s[start - 1] == '_' &&
            (forall k :: end <= k < i ==> IsLowercaseLetter(s[k])))
    {
        if s[i] == '_' {
            // Check for lowercase sequence before the underscore
            var startIdx := i - 1;
            while startIdx >= 0 && IsLowercaseLetter(s[startIdx]) {
                startIdx := startIdx - 1;
            }
            startIdx := startIdx + 1; // start of lowercase sequence before underscore
            
            // Check for lowercase sequence after underscore
            var endIdx := i + 1;
            while endIdx < |s| && IsLowercaseLetter(s[endIdx]) {
                endIdx := endIdx + 1;
            }
            
            if startIdx > 0 && endIdx < |s| && startIdx < i && endIdx > i {
                result := true;
                break;
            }
        }
        i := i + 1;
    }
}