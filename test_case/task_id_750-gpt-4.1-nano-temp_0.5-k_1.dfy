method AddTupleToList(lst: seq<int>, t: (int, int)) returns (newList: seq<int>)
    ensures newList == lst + [t.0, t.1]
{
    newList := lst + [t.0, t.1];
}