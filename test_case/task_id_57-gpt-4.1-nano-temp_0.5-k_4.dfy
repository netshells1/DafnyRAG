method LargestNumberFromArray(a: array<int>) returns (result: string)
    requires a != null
    ensures result == ConcatenateLargestNumber(a)
{
    var nums := a[..]; // copy array
    // Convert integers to strings
    var strNums := [for n in nums :: n.ToString()];
    // Sort the strings based on custom comparator
    var sortedStrs := BubbleSort(strNums, StringCompare);
    // Concatenate the sorted strings
    result := "";
    for s in sortedStrs
        invariant true
    {
        result := result + s;
    }
}

// Helper function to compare two strings for sorting
function StringCompare(s1: string, s2: string): int
{
    var concat1 := s1 + s2;
    var concat2 := s2 + s1;
    if concat1 > concat2 then 1
    else if concat1 < concat2 then -1
    else 0
}

// Bubble sort implementation with custom comparator
method BubbleSort(arr: array<string>, cmp: function(string, string): int) returns (sorted: array<string>)
    ensures sorted[..] == arr[..]
{
    var a := arr[..];
    var n := a.Length;
    var swapped := true;
    while swapped
        invariant 0 <= n <= arr.Length
        invariant a[..] == arr[..]
    {
        swapped := false;
        for i := 0 to n - 2
            invariant 0 <= i < n
            invariant a[..] == arr[..]
        {
            if cmp(a[i], a[i+1]) < 0 {
                var temp := a[i];
                a[i] := a[i+1];
                a[i+1] := temp;
                swapped := true;
            }
        }
        n := n - 1;
    }
    sorted := a;
}

// Function to produce the largest number by concatenation
function ConcatenateLargestNumber(a: array<int>): string
{
    var strArr := [for n in a :: n.ToString()];
    var sortedStrs := BubbleSort(strArr, StringCompare);
    var res := "";
    for s in sortedStrs
        invariant true
    {
        res := res + s;
    }
    res
}