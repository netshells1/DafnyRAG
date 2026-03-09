method RemoveFirstAndLastOccurrence(s: string, c: char) returns (v: string)
  ensures
    // Length of v equals length of s minus 1 if c occurs at least once, else same length
    |v| == |s| - (if exists i :: 0 <= i < |s| && s[i] == c then 1 else 0)
    // v contains no occurrence of c
    (forall i :: 0 <= i < |v| ==> v[i] != c)
    // v is s with first and last occurrence of c removed
{
    var firstIndex := -1;
    var lastIndex := -1;
    var n := |s|;
    var i := 0;
    // Find first occurrence of c
    while i < n
      invariant 0 <= i <= n
      invariant firstIndex == -1 ==> (exists j :: 0 <= j < i && s[j] == c)
      invariant firstIndex != -1 ==> 0 <= firstIndex < i
    {
      if s[i] == c && firstIndex == -1 {
        firstIndex := i;
      }
      i := i + 1;
    }
    // Find last occurrence of c
    i := n - 1;
    while i >= 0
      invariant -1 <= i < n
      invariant lastIndex == -1 ==> (exists j :: i+1 <= j < n && s[j] == c)
      invariant lastIndex != -1 ==> i+1 <= lastIndex < n
    {
      if s[i] == c && lastIndex == -1 {
        lastIndex := i;
      }
      i := i - 1;
    }
    // Build v by skipping first and last occurrence of c
    v := "";
    i := 0;
    while i < n
      invariant 0 <= i <= n
      invariant v == (if i == 0 then "" else v[.. i])
      invariant
        (forall j :: 0 <= j < i ==> s[j] != c) // characters before i are processed
    {
      if (i == firstIndex || i == lastIndex) {
        // skip this character
        i := i + 1;
      } else {
        v := v + [s[i]];
        i := i + 1;
      }
    }
}