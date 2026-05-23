method FindFirstNonRepeatedChar(s: string) returns (found: bool, c: char)
    ensures found ==> exists i :: 0 <= i < |s| && s[i] == c && (forall j :: 0 <= j < |s| && j != i ==> s[j] != c)
    ensures !found ==> (|s| == 0 || (forall i, j :: 0 <= i < |s| && 0 <= j < |s| && i != j ==> s[i] != s[j]))
{
    if |s| == 0 {
        found := false;
        c := ' ';
        return;
    }
    var i := 0;
    found := false;
    c := ' ';
    while i < |s| && !found
        invariant 0 <= i <= |s|
        invariant !found ==> (forall k :: 0 <= k < i ==> s[k] != s[i])
        invariant found ==> exists k :: 0 <= k < i && s[k] == s[i]
    {
        var j := 0;
        var isUnique := true;
        while j < |s|
            invariant 0 <= j <= |s|
            invariant isUnique ==> (forall m :: 0 <= m < j ==> s[m] != s[j])
            invariant !isUnique ==> (exists m :: 0 <= m < j && s[m] == s[j])
        {
            if j != i && s[j] == s[i] {
                isUnique := false;
            }
            j := j + 1;
        }
        if isUnique {
            found := true;
            c := s[i];
        }
        i := i + 1;
    }
}