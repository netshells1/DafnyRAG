method FirstWithSmallestSecond(s: array<int>) returns (value: int)
    requires s.Length >= 1
    ensures exists i :: 0 <= i < s.Length && s[i] == value && forall j :: 0 <= j < s.Length && s[j] != value ==> s[j] >= s[i]
{
    var minSecond := s[0];
    var minIndex := 0;
    var i := 1;
    while i < s.Length
        invariant 1 <= i <= s.Length
        invariant minIndex >= 0 && minIndex < i
        invariant minSecond == s[minIndex]
        invariant forall j :: 0 <= j < i ==> s[j] >= minSecond
    {
        if s[i] < minSecond {
            minSecond := s[i];
            minIndex := i;
        }
        i := i + 1;
    }
    value := s[minIndex];
}