method LargestNumber(a: array<int>) returns (result: int)
    requires a != null
    requires a.Length > 0
    ensures result == NumberFromDigits(a)
{
    var digits := a[..];
    // Convert integers to strings for concatenation
    var strDigits := [for d in digits :: d.ToString()];
    // Sort the string digits based on custom comparator
    var sortedStrDigits := SortStringsDescending(strDigits);
    var concatenated := string.Join("", sortedStrDigits);
    result := int.Parse(concatenated);
}

// Helper function to sort strings based on custom comparator for largest number
function method SortStringsDescending(s: seq<string>): seq<string>
    ensures forall i, j :: 0 <= i < j < |s| ==> s[i] >= s[j]
{
    // Implement a simple sorting algorithm with custom comparator
    // For simplicity, assume a built-in sort with comparator
    // Since Dafny does not have built-in sort with comparator, we simulate via insertion sort
    var res := s;
    var n := |res|;
    var i := 1;
    while i < n
        invariant 0 <= i <= n
        invariant forall k, l :: 0 <= k < l < i ==> res[k] >= res[l]
    {
        var j := i;
        while j > 0 && CompareStrings(res[j - 1], res[j]) < 0
            invariant 0 <= j <= i
            invariant forall k, l :: 0 <= k < l < j ==> res[k] >= res[l]
        {
            var tmp := res[j - 1];
            res := res[0..j - 1] + [res[j]] + res[j - 1 + 1..];
            res := res[0..j - 1] + [res[j + 1]] + [res[j]] + res[j + 2..];
            j := j - 1;
        }
        i := i + 1;
    }
    res
}

// Comparator for strings representing digits
function method CompareStrings(a: string, b: string): int
{
    // Compare concatenations a+b and b+a
    if a + b > b + a then
        1
    else if a + b < b + a then
        -1
    else
        0
}

// Function to convert array of integers to a number formed by concatenation
function method NumberFromDigits(a: array<int>): int
{
    var s := "";
    for d in a
        s := s + d.ToString();
    int.Parse(s)
}