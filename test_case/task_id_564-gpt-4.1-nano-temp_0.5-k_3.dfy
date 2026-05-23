method CountUnequalPairs(lst: seq<int>) returns (count: int)
    ensures 0 <= count <= |lst| * (|lst| - 1) / 2
    ensures count == |{ (i, j) | 0 <= i < j < |lst| && lst[i] != lst[j] }|
{
    var c := 0;
    for i := 0 to |lst| - 2
        invariant 0 <= i <= |lst| - 1
        invariant 0 <= c <= |lst| * (|lst| - 1) / 2
        invariant c == |{ (k, l) | 0 <= k < l <= i && lst[k] != lst[l] }|
    {
        var j := i + 1;
        while j < |lst|
            invariant i + 1 <= j <= |lst|
            invariant c == |{ (k, l) | 0 <= k < l <= i || (i < l <= j && lst[k] != lst[l]) }|
        {
            if lst[i] != lst[j]
            {
                c := c + 1;
            }
            j := j + 1;
        }
    }
    count := c;
}