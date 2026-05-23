predicate IsUpperCase(c: char)
{
    65 <= c as int <= 90
}

method MaxUpperRun(s: string) returns (maxRun: int)
    ensures maxRun >= 0
    ensures exists i :: 0 <= i <= |s| - maxRun && forall k :: i <= k < i + maxRun ==> IsUpperCase(s[k])
    ensures forall start :: 0 <= start <= |s| - maxRun + 1
             (exists k :: start <= k < start + maxRun && IsUpperCase(s[k])) &&
             (start == 0 || (start - 1 >= 0 ==> s[start - 1] !? IsUpperCase(s[start - 1])))
             && (start + maxRun == |s| || (start + maxRun <= |s| && forall k :: start + maxRun <= k < |s| ==> s[k] !? IsUpperCase(s[k])))
{
    maxRun := 0;
    var currentRun := 0;
    var startIndex := 0;
    var maxStartIndex := 0;
    var i := 0;
    while i <= |s|
        invariant 0 <= i <= |s| + 1
        invariant maxRun >= 0
        invariant currentRun >= 0
        invariant maxRun >= currentRun
        invariant 0 <= startIndex <= i
        invariant 0 <= maxStartIndex <= i
        invariant (exists k :: maxStartIndex <= k < maxStartIndex + maxRun && IsUpperCase(s[k]))
        invariant (forall k :: 0 <= k < startIndex ==> s[k] !? IsUpperCase(s[k]))
        invariant (forall k :: startIndex <= k < i ==> s[k] !? IsUpperCase(s[k]))
    {
        if i == |s| || !IsUpperCase(s[i]) {
            if currentRun > maxRun {
                maxRun := currentRun;
                maxStartIndex := startIndex;
            }
            currentRun := 0;
            startIndex := i + 1;
        } else {
            if currentRun == 0 {
                startIndex := i;
            }
            currentRun := currentRun + 1;
        }
        i := i + 1;
    }
    // After loop, maxRun and maxStartIndex record the maximum run
}