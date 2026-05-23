method ClosestSmaller(s: array<int>, n: int) returns (result: int)
    requires s != null
    ensures (exists x :: x in s[..] && x < n && (forall y :: y in s[..] && y < n ==> y <= x))
    // If no element less than n exists, result is -1
{
    var maxLess := -1;
    var found := false;
    var i := 0;
    while i < s.Length
        invariant 0 <= i <= s.Length
        invariant (found ==> forall y :: y in s[..i] && y < n ==> y <= maxLess)
        invariant (!found ==> forall y :: y in s[..i] ==> y >= n || y < 0) // no update yet
    {
        if s[i] < n
        {
            if !found || s[i] > maxLess
            {
                maxLess := s[i];
                found := true;
            }
        }
        i := i + 1;
    }
    if found {
        result := maxLess;
    } else {
        result := -1;
    }
}