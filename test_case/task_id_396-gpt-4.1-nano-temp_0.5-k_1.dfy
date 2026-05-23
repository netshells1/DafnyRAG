method StartsAndEndsWithSameChar(s: string) returns (result: bool)
  requires s != null
  ensures result <==> (|s| > 0 && s[0] == s[|s| - 1])
{
    if |s| == 0 {
        result := false;
    } else {
        result := s[0] == s[|s| - 1];
    }
}