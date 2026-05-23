method LargestNegative(s: array<int>) returns (largestNeg: int)
    requires exists i :: 0 <= i < s.Length && s[i] < 0
    ensures exists i :: 0 <= i < s.Length && s[i] == largestNeg && s[i] < 0
    ensures forall i :: 0 <= i < s.Length && s[i] < 0 ==> s[i] <= largestNeg
{
    var foundNeg := false;
    // Initialize largestNeg to 0; since array may have no negatives, but precondition ensures at least one negative
    largestNeg := 0;
    // To satisfy the ensures, we need to initialize largestNeg to a negative number from s
    // Find the first negative number to initialize largestNeg
    var i := 0;
    while i < s.Length
        invariant 0 <= i <= s.Length
        invariant exists k :: 0 <= k < i && s[k] < 0 ==> largestNeg == s[k]
        invariant forall k :: 0 <= k < i && s[k] < 0 ==> s[k] <= largestNeg
    {
        if s[i] < 0
        {
            largestNeg := s[i];
            foundNeg := true;
            break;
        }
        i := i + 1;
    }
    // Now, iterate over remaining elements to find the maximum negative
    var j := i + 1;
    while j < s.Length
        invariant i + 1 <= j <= s.Length
        invariant exists k :: 0 <= k < i + 1 && s[k] < 0 ==> largestNeg == s[k]
        invariant forall k :: 0 <= k < i + 1 && s[k] < 0 ==> s[k] <= largestNeg
        invariant exists k :: 0 <= k < j && s[k] < 0 && s[k] > largestNeg ==> largestNeg < s[k]
    {
        if s[j] < 0 && s[j] > largestNeg
        {
            largestNeg := s[j];
        }
        j := j + 1;
    }
}