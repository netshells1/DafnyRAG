method SumUniqueElements(lst: seq<int>) returns (sum: int)
    ensures sum == sum { x | x in lst && |lst|x| == 1 }
{
    var counts := new map<int, int>();
    // Count occurrences
    for x in lst
        invariant counts.Keys() == set x | x in lst
        decreases |lst| - |sequence of processed elements|
    {
        if x in counts {
            counts[x] := counts[x] + 1;
        } else {
            counts := counts[x := 1] + counts;
        }
    }
    sum := 0;
    for x in lst
        invariant sum >= 0
        invariant counts[x] >= 1
        decreases |lst| - |sequence of processed elements|
    {
        if counts[x] == 1 {
            sum := sum + x;
        }
    }
}