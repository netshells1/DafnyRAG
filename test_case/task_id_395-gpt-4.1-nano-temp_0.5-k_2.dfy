method FindFirstNonRepeatedChar(s: string) returns (found: bool, c: char)
    requires s != null
    ensures found ==> exists i :: 0 <= i < |s| && s[i] == c && (forall j :: 0 <= j < |s| && s[j] == s[i] ==> j == i)
    ensures !found ==> (forall i, j :: 0 <= i < |s| && 0 <= j < |s| && i != j ==> s[i] != s[j])
{
    var counts := new int[256]; // assuming ASCII characters
    var i := 0;
    // Count occurrences of each character
    while i < |s|
        invariant 0 <= i <= |s|
        invariant forall k :: 0 <= k < 256 ==> counts[k] >= 0
        decreases |s| - i
    {
        var ch := s[i];
        counts[ch] := counts[ch] + 1;
        i := i + 1;
    }
    // Find first character with count == 1
    var j := 0;
    found := false;
    c := '\0'; // default value
    while j < |s| && !found
        invariant 0 <= j <= |s|
        invariant (forall k :: 0 <= k < j ==> counts[s[k]] >= 1)
        invariant (exists i :: 0 <= i < j && s[i] == s[j] && counts[s[j]] == 1) ==> found
        decreases |s| - j
    {
        if counts[s[j]] == 1 {
            found := true;
            c := s[j];
        }
        j := j + 1;
    }
}