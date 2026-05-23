/// <summary>
/// Converts a sequence of positive integers into a single concatenated integer.
/// For example, [12, 345, 6] -> 123456
/// </summary>
method SequenceToInteger(seq: seq<int>) returns (result: int)
    requires forall x :: x in seq ==> x > 0
    ensures result >= 0
    ensures result == ConcatenateSequence(seq)
{
    result := 0;
    var multiplier := 1;
    // Process sequence from end to start to build the number
    var i := |seq| - 1;
    while i >= 0
        invariant -1 <= i < |seq|
        invariant result >= 0
        invariant result == ConcatenateSequence(seq[..i+1]) // Using a helper function
    {
        var x := seq[i];
        var len_x := NumberOfDigits(x);
        // Shift current result to the left to make space for x
        result := result + x * Power10(len_x) * multiplier;
        // Update multiplier for next iteration
        multiplier := Power10(len_x) * multiplier;
        i := i - 1;
    }
}

/// <summary>
/// Helper function to compute 10^n
/// </summary>
function Power10(n: nat): nat
    ensures Power10(n) >= 1
{
    if n == 0 then 1 else 10 * Power10(n - 1)
}

/// <summary>
/// Helper function to compute the number of digits in a positive integer
/// </summary>
function NumberOfDigits(x: int): nat
    requires x > 0
{
    if x < 10 then 1 else 1 + NumberOfDigits(x / 10)
}

/// <summary>
/// Helper predicate to define concatenation of sequence elements into an integer
/// </summary>
function ConcatenateSequence(s: seq<int>): int
    requires forall x :: x in s ==> x > 0
{
    if |s| == 0 then 0
    else
        var last := s[|s| - 1];
        var prefix := ConcatenateSequence(s[..|s|-1]);
        prefix * Power10(NumberOfDigits(last)) + last
}