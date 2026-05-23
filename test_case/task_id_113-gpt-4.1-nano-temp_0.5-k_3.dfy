method IsIntegerString(s: string) returns (result: bool)
  ensures result <==> (exists prefix: string, digits: string ::
        s == prefix + digits &&
        (prefix == "" || prefix == "-") &&
        digits != "" &&
        (forall i :: 0 <= i < |digits| ==> '0' <= digits[i] <= '9'))
{
    var i := 0;
    var signDetected := false;
    var digitsStart := 0;

    // Check for optional sign at the start
    if |s| > 0 && (s[0] == '-') {
        signDetected := true;
        i := 1;
    }

    var allDigits := true;
    while i < |s|
        invariant 0 <= i <= |s|
        invariant (signDetected ==> i >= 1)
        invariant allDigits
        // If any character is not a digit, allDigits becomes false
    {
        if !('0' <= s[i] <= '9') {
            allDigits := false;
        }
        i := i + 1;
    }

    result := (allDigits && (i > (if signDetected then 1 else 0)));
}