method NoDuplicates(s: seq<int>) returns (result: bool)
    ensures result <==> (forall i, j :: 0 <= i < j < |s| ==> s[i] != s[j])
{
    result := true;
    var i := 0;
    while i < |s|
        invariant 0 <= i <= |s|
        invariant result <==> (forall x, y :: 0 <= x < y < i ==> s[x] != s[y])
    {
        var j := i + 1;
        while j < |s|
            invariant i + 1 <= j <= |s|
            invariant result <==> (result && (forall x :: 0 <= x < i ==> s[x] != s[j]))
        {
            if s[i] == s[j] {
                result := false;
                return;
            }
            j := j + 1;
        }
        i := i + 1;
    }
}