method CountUnequalPairs(lst: seq<int>) returns (count: int)
    requires lst != null
    ensures count == |{ (i, j) | 0 <= i < j < |lst| && lst[i] != lst[j] }|
{
    var res: set<(int, int)> := {};
    var n := |lst|;
    var i := 0;
    while i < n
        invariant 0 <= i <= n
        invariant res == { (x, y) | exists i', j' :: 0 <= i' < j' < i && lst[i'] != lst[j'] }
        decreases n - i
    {
        var j := i + 1;
        while j < n
            invariant i + 1 <= j <= n
            invariant res == { (x, y) | exists i', j' :: 0 <= i' < j' < i && lst[i'] != lst[j'] } 
                       + { (i, j) | i < j && lst[i] != lst[j] }
            decreases n - j
        {
            if lst[i] != lst[j] {
                res := res + {(i, j)};
            }
            j := j + 1;
        }
        i := i + 1;
    }
    count := |res|;
}