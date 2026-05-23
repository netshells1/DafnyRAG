predicate IsDigit(c: char)
{
    48 <= c as int <= 57
}

predicate IsValidDecimalFormat(s: string)
{
    // Check for optional sign at start
    var startIdx := 0;
    if |s| > 0 && (s[0] == '-' || s[0] == '+') {
        startIdx := 1;
    }
    // Find position of decimal point if any
    var dotIndex := -1;
    var i := startIdx;
    while i < |s|
        invariant startIdx <= i <= |s|
        invariant (dotIndex == -1) || (0 <= dotIndex < |s|)
        invariant (dotIndex == -1) ==> (forall k :: startIdx <= k < i ==> s[k] != '.')
        invariant (dotIndex != -1) ==> (startIdx <= dotIndex < i)
    {
        if s[i] == '.' {
            if dotIndex == -1 {
                dotIndex := i;
            } else {
                // More than one decimal point invalid
                return false;
            }
        }
        i := i + 1;
    }
    // Validate digits before decimal point
    var endIdx := if dotIndex == -1 then |s| else dotIndex;
    if endIdx == startIdx then
        // No digits before decimal point
        return false;
    for k := startIdx to endIdx - 1
        invariant startIdx <= k <= endIdx
        invariant endIdx <= |s|
    {
        if !IsDigit(s[k]) {
            return false;
        }
    }
    // Validate digits after decimal point if decimal exists
    if dotIndex != -1 {
        var fractionalStart := dotIndex + 1;
        var fractionalEnd := |s|;
        if fractionalEnd - fractionalStart > 2 {
            return false;
        }
        for k := fractionalStart to fractionalEnd - 1
            invariant fractionalStart <= k <= fractionalEnd
        {
            if !IsDigit(s[k]) {
                return false;
            }
        }
    }
    return true;
}

method IsDecimalWithTwoPrecision(s: string) returns (result: bool)
    ensures result <==> IsValidDecimalFormat(s)
{
    result := IsValidDecimalFormat(s);
}