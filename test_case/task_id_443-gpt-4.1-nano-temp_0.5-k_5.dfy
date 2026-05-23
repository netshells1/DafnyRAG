method FindLargestNegative(s: array<int>) returns (maxNeg: int)
    requires s.Length > 0
    requires exists i :: 0 <= i < s.Length && s[i] < 0
    ensures exists i :: 0 <= i < s.Length && s[i] == maxNeg && s[i] < 0
    ensures forall i :: 0 <= i < s.Length && s[i] < 0 ==> s[i] <= maxNeg
{
    // Initialize maxNeg to the first negative number found
    var i := 0;
    // Find the first negative number to initialize maxNeg
    while i < s.Length && s[i] >= 0
        invariant 0 <= i <= s.Length
        invariant exists j :: 0 <= j < i && s[j] < 0
        decreases s.Length - i
    {
        i := i + 1;
    }
    // Now, s[i] is the first negative number
    maxNeg := s[i];

    var j := i + 1;
    while j < s.Length
        invariant i < j <= s.Length
        invariant exists k :: 0 <= k < i && s[k] < 0
        invariant forall k :: 0 <= k < j && s[k] < 0 ==> s[k] <= maxNeg
        decreases s.Length - j
    {
        if s[j] < 0 && s[j] > maxNeg
        {
            maxNeg := s[j];
        }
        j := j + 1;
    }
}