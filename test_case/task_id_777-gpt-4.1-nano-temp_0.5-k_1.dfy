method SumOfUniqueElements(lst: seq<int>) returns (sum: int)
    ensures sum == SumOfElementsWithCountOne(lst)
{
    var total := 0;
    var seen: set<int> := {};
    var processed: set<int> := {};

    // Iterate over each element in the sequence
    for i := 0 to |lst|
        invariant 0 <= i <= |lst|
        invariant seen == { lst[j] | 0 <= j < i }
        invariant processed == { lst[j] | 0 <= j < i }
        // The sum of elements with count one among processed elements
        invariant sum == SumOfElementsWithCountOneInSeq(lst, processed)
    {
        var current := lst[i];
        if current in seen {
            // Already processed this element
            continue;
        }
        // Count how many times current appears in lst
        var count := CountOccurrences(lst, current);
        if count == 1 {
            total := total + current;
        }
        seen := seen + { current };
        processed := processed + { current };
    }
    sum := total;
}

// Helper function: counts how many times 'val' appears in 'lst'
function CountOccurrences(lst: seq<int>, val: int): nat
    decreases lst
{
    if |lst| == 0 then 0
    else if lst[0] == val then 1 + CountOccurrences(lst[1..], val)
    else CountOccurrences(lst[1..], val)
}

// Helper function: sum of elements in 'lst' that occur exactly once
function SumOfElementsWithCountOne(lst: seq<int>): int
{
    var total := 0;
    var processed: set<int> := {};
    for i := 0 to |lst|
        invariant 0 <= i <= |lst|
        invariant processed == { lst[j] | 0 <= j < i }
        invariant total == sum of all elements in processed that occur exactly once
    {
        var current := lst[i];
        if current in processed {
            continue;
        }
        var count := CountOccurrences(lst, current);
        if count == 1 {
            total := total + current;
        }
        processed := processed + { current };
    }
    total
}