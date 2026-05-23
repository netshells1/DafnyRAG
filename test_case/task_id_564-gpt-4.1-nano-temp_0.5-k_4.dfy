method CountUnequalPairs(lst: seq<int>) returns (count: int)
    ensures 0 <= count <= |lst| * (|lst| - 1) / 2
    ensures count == |{ (i, j) | 0 <= i < j < |lst| && lst[i] != lst[j] }|
{
    var res: nat := 0;
    var n := |lst|;
    for i := 0 to n - 2
        invariant 0 <= i <= n - 1
        invariant res <= (i * (i + 1)) / 2
    {
        for j := i + 1 to n - 1
            invariant i + 1 <= j <= n
            invariant res <= (i * (i + 1)) / 2 + (j - i - 1)
        {
            if lst[i] != lst[j]
            {
                res := res + 1;
            }
        }
    }
    count := res;
}