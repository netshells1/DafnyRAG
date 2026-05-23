method ExistsInSequence(s1: seq<int>, s2: seq<int>) returns (result: bool)
    ensures result <==> (exists x :: x in s1 && x in s2)
{
    result := false;
    var i := 0;
    while i < |s1|
        invariant 0 <= i <= |s1|
        invariant result <==> (exists k :: 0 <= k < i && s1[k] in s2)
    {
        if s2.Contains(s1[i]) {
            result := true;
            return;
        }
        i := i + 1;
    }
}