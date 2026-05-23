method SumUniqueElements(lst: seq<int>) returns (sum: int)
    ensures sum == SumOfUniqueElements(lst)
{
    var total := 0;
    var counts := new Dictionary<int, int>();
    
    // Count occurrences of each element
    foreach x in lst
        invariant counts != null
        invariant forall k :: k in counts.Keys ==> counts[k] >= 1
    {
        if x in counts {
            counts[x] := counts[x] + 1;
        } else {
            counts[x] := 1;
        }
    }
    
    // Sum elements that occur exactly once
    sum := 0;
    foreach x in lst
        invariant sum >= 0
        invariant forall k :: k in counts.Keys ==> counts[k] >= 1
        decreases lst.Length - |lst| // Not decreasing, but included for clarity
    {
        if counts[x] == 1 {
            sum := sum + x;
        }
    }
}

// Helper function: SumOfUniqueElements
function SumOfUniqueElements(s: seq<int>): int
{
    var counts := new Dictionary<int, int>();
    var sum := 0;
    var visited := new set<int>();
    // Count occurrences
    for x in s
        invariant counts != null
        invariant forall k :: k in counts.Keys ==> counts[k] >= 1
    {
        if x in counts {
            counts[x] := counts[x] + 1;
        } else {
            counts[x] := 1;
        }
    }
    // Sum unique elements
    for x in s
        invariant sum >= 0
        invariant forall k :: k in counts.Keys ==> counts[k] >= 1
    {
        if counts[x] == 1 && x !in visited {
            sum := sum + x;
            visited := visited + {x};
        }
    }
    sum
}