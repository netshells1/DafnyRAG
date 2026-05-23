method FindFirstNonRepeatedChar(s: string) returns (found: bool, c: char)
    requires s != null
    ensures found ==> (forall i :: 0 <= i < |s| ==> s[i] == c) ==> (forall j :: 0 <= j < |s| ==> s[j] != c)
    ensures !found ==> (forall i, j :: 0 <= i < |s| && 0 <= j < |s| ==> s[i] != s[j])
{
    found := false;
    c := ' ';
    var i := 0;
    while i < |s| && !found
        invariant 0 <= i <= |s|
        invariant !found ==> (forall k :: 0 <= k < i ==> (exists l :: 0 <= l < |s| && s[l] == s[k] && l != k))
        invariant found ==> (forall j :: 0 <= j < i ==> (exists l :: 0 <= l < |s| && s[l] == s[j] && l != j))
    {
        var isUnique := true;
        var j := 0;
        while j < |s|
            invariant 0 <= j <= |s|
            invariant isUnique ==> (forall l :: 0 <= l < |s| && l != j ==> s[l] != s[j])
        {
            if j != i && s[j] == s[i]
            {
                isUnique := false;
                break;
            }
            j := j + 1;
        }
        if isUnique
        {
            found := true;
            c := s[i];
        }
        i := i + 1;
    }
}