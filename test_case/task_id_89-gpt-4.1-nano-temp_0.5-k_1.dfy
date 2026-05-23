method ClosestSmaller(s: array<int>, n: int) returns (result: int?)
    requires s != null
    ensures result == null ==> forall x :: x in s ==> x >= n
    ensures result != null ==> result in s && result < n && forall x :: x in s && x < n ==> x <= result
{
    var maxSmaller := if s.Length == 0 then null else s[0];
    var found := s.Length > 0 && s[0] < n;
    var i := 0;
    while i < s.Length
        invariant 0 <= i <= s.Length
        invariant (exists x :: x in s[..i] && x < n) ==> (result != null && result in s[..i] && result < n && forall x :: x in s[..i] && x < n ==> x <= result)
        invariant (forall x :: x in s[..i] ==> x >= n) ==> result == null
        invariant (exists x :: x in s[..i] && x < n) ==> result != null && result in s[..i] && result < n && forall x :: x in s[..i] && x < n ==> x <= result
        decreases s.Length - i
    {
        if s[i] < n
        {
            if found
            {
                if s[i] > maxSmaller
                {
                    maxSmaller := s[i];
                }
            } else
            {
                maxSmaller := s[i];
                found := true;
            }
        }
        i := i + 1;
    }
    if found then result := maxSmaller else result := null;
}