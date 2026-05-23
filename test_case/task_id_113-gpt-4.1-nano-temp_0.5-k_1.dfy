method IsIntegerString(s: string) returns (result: bool)
    ensures result <==> (exists start: int :: 0 <= start <= |s| &&
                          ((start == 0 && (s[0] == '+' || s[0] == '-')) ==> 
                              1 <= |s|) &&
                          (forall i: int :: start <= i < |s| ==> '0' <= s[i] <= '9') &&
                          (start == 0 || (s[0] == '+' || s[0] == '-')))
    ensures result ==> (|s| > 0)
    ensures !result ==> (|s| == 0 || (s[0] != '+' && s[0] != '-') && exists i: int :: 0 <= i < |s| && '0' <= s[i] <= '9')
{
    result := false;
    if |s| == 0 {
        return;
    }

    var start := 0;
    if s[0] == '+' || s[0] == '-' {
        if |s| == 1 {
            return;
        }
        start := 1;
    }

    var allDigits := true;
    var i := start;
    while i < |s|
        invariant start <= i <= |s|
        invariant allDigits ==> (forall k: int :: start <= k < i ==> '0' <= s[k] <= '9')
    {
        if s[i] < '0' || s[i] > '9' {
            allDigits := false;
            break;
        }
        i := i + 1;
    }
    result := allDigits && (i == |s|);
}