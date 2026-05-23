method CountLists(lists: seq<seq<int>>) returns (count: int)
    ensures count == |lists|
{
    count := 0;
    var i := 0;
    while i < |lists|
        invariant 0 <= i <= |lists|
        invariant count == i
    {
        count := count + 1;
        i := i + 1;
    }
}