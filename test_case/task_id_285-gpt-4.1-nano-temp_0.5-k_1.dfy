method ContainsAFollowedByTwoOrThreeB(s: string) returns (result: bool)
  ensures result <==> (exists i :: 0 <= i < |s| && s[i] == 'a' && ( (i + 2 < |s| && s[i+1] == 'b' && s[i+2] == 'b') || (i + 3 < |s| && s[i+1] == 'b' && s[i+2] == 'b' && s[i+3] == 'b') ))
{
    result := false;
    var i := 0;
    while i < |s|
        invariant 0 <= i <= |s|
        invariant result <==> (exists k :: 0 <= k < i && s[k] == 'a' && ( (k + 2 < |s| && s[k+1] == 'b' && s[k+2] == 'b') || (k + 3 < |s| && s[k+1] == 'b' && s[k+2] == 'b' && s[k+3] == 'b') ))
    {
        if s[i] == 'a' && i + 2 < |s| && s[i+1] == 'b' && s[i+2] == 'b' {
            result := true;
            break;
        } else if s[i] == 'a' && i + 3 < |s| && s[i+1] == 'b' && s[i+2] == 'b' && s[i+3] == 'b' {
            result := true;
            break;
        }
        i := i + 1;
    }
}