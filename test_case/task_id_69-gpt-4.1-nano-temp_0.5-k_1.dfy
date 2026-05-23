method ContainsSequence(seqList: seq<seq<int>>, target: seq<int>) returns (result: bool)
    ensures result <==> (exists s :: s in seqList && s == target)
{
    result := false;
    var i := 0;
    while i < |seqList|
        invariant 0 <= i <= |seqList|
        invariant result <==> (exists s :: s in seqList[..i] && s == target)
    {
        if seqList[i] == target {
            result := true;
            return;
        }
        i := i + 1;
    }
}