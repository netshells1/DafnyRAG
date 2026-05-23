method ListContainsSequence(lst: seq<seq<int>>, pattern: seq<int>) returns (result: bool)
{
    result := false;
    var i := 0;
    while i < |lst|
        invariant 0 <= i <= |lst|
        invariant result <==> (exists k :: 0 <= k < i && lst[k] == pattern)
    {
        if lst[i] == pattern {
            result := true;
            break;
        }
        i := i + 1;
    }
}