method IsIntegerString(s: string) returns (result: bool)
    ensures result <==> (
        exists prefix: string ::
            (prefix == "" || prefix == "+" || prefix == "-") &&
            |prefix| <= |s| &&
            (forall i :: 0 <= i < |s| - |prefix| ==> s[prefix.Length + i] in ['0'..'9'])
    )
{
    var startIndex := 0;
    var prefix := "";
    if |s| > 0 && (s[0] == '+' || s[0] == '-') {
        prefix := s[0..1];
        startIndex := 1;
    }

    // Check that all remaining characters are digits
    var allDigits := true;
    var i := startIndex;
    while i < |s|
        invariant 0 <= i <= |s|
        invariant allDigits ==> (forall k :: startIndex <= k < i ==> s[k] in ['0'..'9'])
        invariant !allDigits ==> (exists k :: startIndex <= k < i && s[k] !in ['0'..'9'])
    {
        if s[i] !in ['0'..'9'] {
            allDigits := false;
            break;
        }
        i := i + 1;
    }
    result := allDigits && (i >= startIndex);
}