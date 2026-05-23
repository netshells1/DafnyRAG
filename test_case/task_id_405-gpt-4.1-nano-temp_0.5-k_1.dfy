method Contains(seq: seq<int>, elem: int) returns (result: bool)
    ensures result <==> (elem in seq)
{
    result := false;
    var i := 0;
    while i < |seq|
        invariant 0 <= i <= |seq|
        invariant result <==> (exists j :: 0 <= j < i && seq[j] == elem)
    {
        if seq[i] == elem {
            result := true;
        }
        i := i + 1;
    }
}