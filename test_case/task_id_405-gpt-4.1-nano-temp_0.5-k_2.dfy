method ExistsInSequence(s: seq<int>, x: int) returns (result: bool)
    ensures result <==> (x in s)
{
    result := false;
    var i := 0;
    while i < |s|
        invariant 0 <= i <= |s|
        invariant result <==> (x in s[0..i])
    {
        if s[i] == x {
            result := true;
            break;
        }
        i := i + 1;
    }
}