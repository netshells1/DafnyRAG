predicate IsDigit(c: char)
{
    48 <= c as int <= 57
}

predicate ValidIntegerString(s: string)
{
    |s| > 0 &&
    (s[0] == '-' || s[0] == '+') ==> |s| > 1 &&
    (s[0] == '-' || s[0] == '+') ==> forall i :: 1 <= i < |s| ==> IsDigit(s[i]) &&
    (s[0] != '-' && s[0] != '+') ==> forall i :: 0 <= i < |s| ==> IsDigit(s[i])
}

method IsIntegerString(s: string) returns (result: bool)
    ensures result <==> ValidIntegerString(s)
{
    result := false;
    if |s| == 0 {
        return;
    }
    var firstChar := s[0];
    var startIndex := 1;
    if firstChar == '-' || firstChar == '+' {
        if |s| == 1 {
            return;
        }
        startIndex := 1;
    } else {
        startIndex := 0;
    }
    var allDigits := true;
    var i := startIndex;
    while i < |s|
        invariant 0 <= i <= |s|
        invariant allDigits ==> forall k :: startIndex <= k < i ==> IsDigit(s[k])
    {
        if !IsDigit(s[i]) {
            allDigits := false;
            break;
        }
        i := i + 1;
    }
    result := allDigits;
}