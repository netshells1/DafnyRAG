predicate IsValidIntegerString(s: string)
{
    // A string is a valid integer if:
    // - It is empty (not valid)
    // - It starts with an optional '+' or '-'
    // - Followed by at least one digit
    if |s| == 0 then
        false
    else
        var startIndex := 0;
        if s[0] == '-' || s[0] == '+' then
            startIndex := 1;
        else
            startIndex := 0;
        // Check that from startIndex to end, all are digits and at least one digit exists
        startIndex < |s| && forall i :: startIndex <= i < |s| ==> IsDigit(s[i])
}

method IsIntegerString(s: string) returns (result: bool)
    ensures result <==> IsValidIntegerString(s)
{
    // The implementation: check the string according to the predicate
    if |s| == 0 {
        return false;
    }
    var startIndex := 0;
    if s[0] == '-' || s[0] == '+' {
        startIndex := 1;
    }
    if startIndex >= |s| {
        // String is only '+' or '-', not a valid number
        return false;
    }
    // Check that all remaining characters are digits
    var allDigits := true;
    var i := startIndex;
    while i < |s|
        invariant startIndex <= i <= |s|
        invariant forall k :: startIndex <= k < i ==> IsDigit(s[k])
    {
        if !IsDigit(s[i]) {
            return false;
        }
        i := i + 1;
    }
    // If loop completes, all are digits
    return true;
}

predicate IsDigit(c: char)
{
    48 <= c as int <= 57
}