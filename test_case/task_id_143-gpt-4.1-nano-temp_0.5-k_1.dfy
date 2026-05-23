method CountArraysInSequence(sequences: seq<array<int>>) returns (count: int)
    ensures 0 <= count
    ensures count == | set a: array<int> | a in sequences && a != null |
{
    var c := 0;
    var i := 0;
    while i < |sequences|
        invariant 0 <= i <= |sequences|
        invariant c == | set a: array<int> | a in sequences[..i] && a != null |
    {
        if sequences[i] != null {
            c := c + 1;
        }
        i := i + 1;
    }
    count := c;
}