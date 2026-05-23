/// Helper function to concatenate sequence of positive integers into a single integer
function method ConcatenateSequence(seq: seq<int>): int
    requires forall x :: x in seq ==> x > 0
    ensures result >= 0
{
    var res := 0;
    var i := 0;
    while i < |seq|
        invariant 0 <= i <= |seq|
        invariant res >= 0
        invariant res == if i == 0 then 0 else ConcatenateSequence(seq[..i])
    {
        res := res * Power10(NumDigits(seq[i])) + seq[i];
        i := i + 1;
    }
    res
}

/// Helper function to compute number of digits in a positive integer
function method NumDigits(n: int): int
    requires n > 0
{
    if n < 10 then 1 else 1 + NumDigits(n / 10)
}

method SequenceToInteger(s: seq<int>) returns (result: int)
    requires forall x :: x in s ==> x > 0
    ensures result >= 0
    ensures result == ConcatenateSequence(s)
{
    var res := 0;
    var i := 0;
    while i < |s|
        invariant 0 <= i <= |s|
        invariant res >= 0
        invariant res == if i == 0 then 0 else ConcatenateSequence(s[..i])
    {
        res := res * Power10(NumDigits(s[i])) + s[i];
        i := i + 1;
    }
    result := res;
}