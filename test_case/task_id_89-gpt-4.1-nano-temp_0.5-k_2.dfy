method ClosestSmaller(s: array<int>, n: int) returns (closest: int)
  requires s != null
  ensures (exists i :: 0 <= i < s.Length && s[i] < n && (forall j :: 0 <= j < s.Length && s[j] < n ==> s[j] <= s[i])) ==> closest == s[i]
  ensures (forall k :: 0 <= k < s.Length ==> s[k] < n) ==> closest == 0
  ensures forall k :: 0 <= k < s.Length && s[k] < n ==> s[k] <= closest
{
    closest := 0;
    var maxLessThanN := -1; // Keep track of the maximum number less than n
    for i := 0 to s.Length
        invariant 0 <= i <= s.Length
        invariant forall k :: 0 <= k < i ==> s[k] < n ==> s[k] <= maxLessThanN
        invariant (exists k :: 0 <= k < i && s[k] < n && s[k] > maxLessThanN) ==> closest == s[k]
    {
        if s[i] < n && s[i] > maxLessThanN {
            maxLessThanN := s[i];
            closest := s[i];
        }
    }
}