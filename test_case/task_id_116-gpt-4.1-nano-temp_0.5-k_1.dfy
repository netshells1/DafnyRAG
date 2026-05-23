/**
 * Converts a sequence of positive integers into a single integer by concatenation.
 */
method SequenceToInteger(seq: seq<int>) returns (result: int)
    requires forall x :: x in seq ==> x > 0
    ensures result >= 0
    ensures result == ConcatenateSequence(seq)
{
    result := 0;
    var multiplier := 1;
    // Process the sequence from the end to the start
    for i := |seq| - 1 to 0 by -1
        invariant 0 <= i < |seq| + 1
        invariant result >= 0
        invariant result == ConcatenatePrefix(seq, i + 1)
        invariant multiplier == Power10(GetDigitsSum(seq, i + 1))
    {
        var x := seq[i];
        var digits := GetDigitsCount(x);
        result := result + x * Power10(GetDigitsSum(seq, i + 1));
        // Update multiplier for the next iteration
        // (though not strictly necessary if we directly compute powers)
    }
}

// Helper function: computes total number of digits in the remaining sequence starting at index i
function GetDigitsSum(seq: seq<int>, start: int): nat
    decreases start
{
    if start >= |seq| then 0
    else GetDigitsCount(seq[start]) + GetDigitsSum(seq, start + 1)
}

// Helper function: counts the number of digits in an integer
function GetDigitsCount(x: int): nat
    requires x > 0
{
    if x < 10 then 1 else 1 + GetDigitsCount(x / 10)
}

// Helper function: computes 10^n
function Power10(n: nat): nat
{
    if n == 0 then 1 else 10 * Power10(n - 1)
}

// Helper function: concatenates the sequence of integers into a single integer
function ConcatenateSequence(seq: seq<int>): int
{
    var res := 0;
    var totalDigits := GetDigitsSum(seq, 0);
    for x in seq
        invariant res >= 0
        invariant res == ConcatenatePrefix(seq, IndexOf(seq, x))
        invariant totalDigits >= 0
    {
        var digits := GetDigitsCount(x);
        res := res * Power10(digits) + x;
        totalDigits := totalDigits - digits;
    }
    res
}

// Helper function: finds index of element in sequence
function IndexOf(seq: seq<int>, x: int): nat
{
    var i := 0;
    while i < |seq|
        invariant 0 <= i <= |seq|
        invariant forall j :: 0 <= j < i ==> seq[j] != x
    {
        if seq[i] == x then return i;
        i := i + 1;
    }
    |seq| // default if not found, should not happen if sequence elements are unique
}