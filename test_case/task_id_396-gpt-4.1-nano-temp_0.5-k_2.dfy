method StartsAndEndsWithSameChar(s: string) returns (result: bool)
    ensures result <==> (|s| > 0 && s[0] == s[|s|-1])
{
    if |s| == 0 {
        return false;
    } else {
        result := s[0] == s[|s|-1];
    }
}