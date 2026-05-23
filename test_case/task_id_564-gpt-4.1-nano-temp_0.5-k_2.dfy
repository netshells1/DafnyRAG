method CountUnequalPairs(lst: seq<int>) returns (count: int)
    ensures count >= 0
    ensures count == |{ (i, j) | 0 <= i < j < |lst| && lst[i] != lst[j] }|
{
    var total := 0;
    var len := |lst|;
    var seen := new set<int>;
    // Count pairs where elements are different
    for i := 0 to len - 1
        invariant 0 <= i <= len
        invariant total >= 0
        // The total counts pairs with i as the second index
        // We will count for each i all j < i with lst[j] != lst[i]
        decreases len - i
    {
        var current := lst[i];
        // For each previous element, check if different
        var innerCount := 0;
        for j := 0 to i - 1
            invariant 0 <= j <= i
            invariant innerCount >= 0
            invariant total == innerCount + (if j > 0 then total - innerCount else total)
            decreases i - j
        {
            if lst[j] != current
            {
                innerCount := innerCount + 1;
            }
        }
        total := total + innerCount;
    }
    count := total;
}