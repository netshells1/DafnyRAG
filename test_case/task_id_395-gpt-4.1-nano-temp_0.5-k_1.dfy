method FindFirstNonRepeatedChar(s: string) returns (found: bool, c: char)
    requires s != null
    ensures found ==> (exists i :: 0 <= i < |s| && (forall j :: 0 <= j < |s| && j != i ==> s[j] != s[i]))
    ensures !found ==> (forall i, j :: 0 <= i < |s| && 0 <= j < |s| && i != j ==> s[i] != s[j])
{
    found := false;
    c := ' ';
    var i := 0;
    while i < |s| && !found
        invariant 0 <= i <= |s|
        invariant found ==> (exists k :: 0 <= k < i && (forall j :: 0 <= j < |s| && j != k ==> s[j] != s[k]))
        invariant !found ==> (forall k :: 0 <= k < i ==> (forall j :: 0 <= j < |s| && j != k ==> s[j] != s[k]))
    {
        var count := 0;
        var index := -1;
        var j := 0;
        while j < |s|
            invariant 0 <= j <= |s|
            invariant count >= 0
            invariant (index == -1) ==> (forall m :: 0 <= m < j ==> s[m] != s[i])
            invariant (index != -1) ==> (forall m :: 0 <= m < j ==> s[m] != s[i] || m >= index)
        {
            if s[j] == s[i] {
                count := count + 1;
                if count > 1 {
                    break;
                }
            }
            j := j + 1;
        }
        if count == 1 {
            found := true;
            c := s[i];
        }
        i := i + 1;
    }
}