method ExistsInOther(seq1: seq<int>, seq2: seq<int>) returns (result: bool)
{
    result := false;
    var i := 0;
    while i < |seq1|
        invariant 0 <= i <= |seq1|
        invariant result <==> (exists k :: 0 <= k < i && seq1[k] in seq2)
    {
        if seq1[i] in seq2 {
            result := true;
            break;
        }
        i := i + 1;
    }
}