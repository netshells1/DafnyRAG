method ContainsK(seq: seq<int>, k: int) returns (result: bool)
 ensures result <==> (k in seq)
{
    result := false;
    var i := 0;
    while i < |seq|
        invariant 0 <= i <= |seq|
        invariant result <==> (k in seq[..i])
    {
        if seq[i] == k {
            result := true;
            break;
        }
        i := i + 1;
    }
}