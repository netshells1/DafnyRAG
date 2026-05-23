/**
 * Converts a sequence of positive integers into a single concatenated integer.
 */
method SequenceToInteger(seq: seq<int>) returns (result: int)
    requires forall x :: x in seq ==> x > 0
    ensures result >= 0
    ensures result == ConcatenateSequence(seq)
{
    result := 0;
    var multiplier := 1;
    // Process the sequence from right to left to build the number
    var i := |seq| - 1;
    while i >= 0
        invariant -1 <= i < |seq|
        invariant result >= 0
        invariant result == SumOfSequence(seq, i+1, |seq|, multiplier)
        invariant multiplier > 0
    {
        var current := seq[i];
        // Determine the number of digits in current
        var digitsCount := NumberOfDigits(current);
        // Update result
        result := result + current * Power10(digitsCount) * multiplier;
        // Update multiplier for next iteration
        multiplier := multiplier * Power10(digitsCount);
        i := i - 1;
    }
}

// Helper function to compute sum of current sequence segment
function SumOfSequence(seq: seq<int>, start: int, end: int, multiplier: int): int
    requires 0 <= start <= end <= |seq|
{
    if start == end then 0
    else seq[start] * Power10(NumberOfDigits(seq[start])) + SumOfSequence(seq, start + 1, end, multiplier)
}

// Helper function to compute number of digits
function NumberOfDigits(n: int): nat
    requires n > 0
{
    if n < 10 then 1 else 1 + NumberOfDigits(n / 10)
}

// Helper function to compute powers of 10
function Power10(n: nat): int
    ensures n >= 0
{
    if n == 0 then 1 else 10 * Power10(n - 1)
}