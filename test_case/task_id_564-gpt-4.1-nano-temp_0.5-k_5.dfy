method CountUnorderedUnequalPairs(lst: seq<int>) returns (count: int)
    ensures count >= 0
    ensures count == |{ (i, j) | 0 <= i < j < |lst| && lst[i] != lst[j] }|
{
    var total := 0;
    var length := |lst|;
    var i := 0;
    while i < length
        invariant 0 <= i <= length
        invariant total == |{ (x, y) | 0 <= x < i && 0 <= y < length && y > x && lst[x] != lst[y] }|
    {
        var j := i + 1;
        while j < length
            invariant i + 1 <= j <= length
            invariant total == |{ (x, y) | 0 <= x < i && 0 <= y < length && y > x && lst[x] != lst[y] }| +
                               |{ y | j <= y < length && lst[i] != lst[y] }|
        {
            if lst[i] != lst[j] {
                total := total + 1;
            }
            j := j + 1;
        }
        i := i + 1;
    }
    count := total;
}