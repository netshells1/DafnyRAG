method FindFirstNonRepeatedChar(s: string) returns (found: bool, c: char)
    ensures found ==> exists i :: 0 <= i < |s| && s[i] == c && (forall j :: 0 <= j < |s| && j != i ==> s[j] != c)
    ensures !found ==> (|s| == 0 || (forall i, j :: 0 <= i < |s| && 0 <= j < |s| && i != j ==> s[i] != s[j]))
{
    var charCounts := map<char, int];
    var i := 0;
    // Count occurrences of each character
    while i < |s|
        invariant 0 <= i <= |s|
        invariant charCounts[..] == map c2 | 0 <= k < i && s[k] in charCounts ==> charCounts[s[k]] || c2
        {
            var ch := s[i];
            if ch in charCounts {
                charCounts[ch] := charCounts[ch] + 1;
            } else {
                charCounts := charCounts + [ch := 1];
            }
            i := i + 1;
        }
    // Find the first character with count == 1
    var j := 0;
    found := false;
    c := ' ';
    while j < |s| && !found
        invariant 0 <= j <= |s|
        invariant (exists i2 :: 0 <= i2 < j && s[i2] == c && (forall k :: 0 <= k < |s| && k != i2 ==> s[k] != c)) ==> found
        invariant (forall k :: 0 <= k < j ==> (s[k] in charCounts && charCounts[s[k]] == 1) ==> (exists i2 :: 0 <= i2 < j && s[i2] == s[k]))
        {
            var ch := s[j];
            if ch in charCounts && charCounts[ch] == 1 {
                found := true;
                c := ch;
            }
            j := j + 1;
        }
}