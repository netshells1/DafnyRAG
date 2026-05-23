/**
 * Converts a sequence of positive integers into a single integer by concatenation.
 */
method SequenceToNumber(seq: seq<int>) returns (result: int)
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
        invariant multiplier >= 1
        invariant result == SumSequence(seq[i+1..]) * multiplier + seq[i]
        invariant multiplier == Power10(TotalDigits(seq[i+1..]))
    {
        var x := seq[i];
        var digits := NumberOfDigits(x);
        result := result + x * Power10(TotalDigits(seq[i+1..]));
        multiplier := multiplier * Power10(digits);
        i := i - 1;
    }
}

/**
 * Helper function to compute total number of digits in a sequence of integers.
 */
function TotalDigits(s: seq<int>): nat
{
    if |s| == 0 then 0 else NumberOfDigits(s[0]) + TotalDigits(s[1..])
}

/**
 * Helper function to compute the number of digits in a positive integer.
 */
function NumberOfDigits(n: int): nat
    requires n > 0
{
    if n < 10 then 1 else 1 + NumberOfDigits(n / 10)
}

/**
 * Helper function to compute 10^n.
 */
function Power10(n: nat): int
{
    if n == 0 then 1 else 10 * Power10(n - 1)
}

/**
 * Helper function to compute the sum of sequence elements.
 */
function SumSequence(s: seq<int>): int
{
    if |s| == 0 then 0 else s[0] + SumSequence(s[1..])
}