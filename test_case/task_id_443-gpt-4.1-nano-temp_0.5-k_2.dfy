method LargestNegative(s: array<int>) returns (largestNeg: int)
    requires s.Length > 0
    requires exists i :: 0 <= i < s.Length && s[i] < 0
    ensures exists i :: 0 <= i < s.Length && s[i] == largestNeg && s[i] < 0
    ensures forall i :: 0 <= i < s.Length && s[i] < 0 ==> s[i] <= largestNeg
{
    var maxNegIndex := 0;
    var foundNeg := false;

    // Initialize largestNeg to a negative value if first element is negative
    if s[0] < 0 {
        largestNeg := s[0];
        foundNeg := true;
    } else {
        // Assign a default negative value; will update if any negative found
        largestNeg := -1;
    }

    for i := 1 to s.Length - 1
        invariant 1 <= i <= s.Length
        invariant foundNeg ==> exists j :: 0 <= j < i && s[j] == largestNeg && s[j] < 0
        invariant !foundNeg ==> forall j :: 0 <= j < i ==> s[j] >= 0
        invariant forall j :: 0 <= j < i && s[j] < 0 ==> s[j] <= largestNeg
    {
        if s[i] < 0 && ( !foundNeg || s[i] > largestNeg ) {
            largestNeg := s[i];
            foundNeg := true;
        }
    }

    // If no negative number was found at initialization, find one now
    if !foundNeg {
        var i := 0;
        while i < s.Length
            invariant 0 <= i <= s.Length
            invariant exists j :: 0 <= j < i && s[j] < 0 && s[j] <= largestNeg
            invariant forall j :: 0 <= j < i && s[j] < 0 ==> s[j] <= largestNeg
        {
            if s[i] < 0 && ( !foundNeg || s[i] > largestNeg) {
                largestNeg := s[i];
                foundNeg := true;
            }
            i := i + 1;
        }
        // At this point, largestNeg holds the largest negative number
        // and the postconditions will be maintained
    }
}