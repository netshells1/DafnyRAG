predicate IsUpperCase(c: char)
{
    65 <= c as int <= 90
}

method MaxUppercaseRun(s: string) returns (maxRun: int)
    ensures 0 <= maxRun <= |s|
    ensures exists i :: 0 <= i <= |s| - maxRun && forall k :: i <= k < i + maxRun ==> IsUpperCase(s[k])
    ensures forall j :: 0 <= j <= |s| - maxRun ==> not exists i :: i <= j <= i + maxRun - 1 && forall k :: i <= k <= i + maxRun - 1 ==> IsUpperCase(s[k])
{
    maxRun := 0;
    var currentRun := 0;
    var startIndex := 0;
    var i := 0;
    while i < |s|
        invariant 0 <= i <= |s|
        invariant 0 <= maxRun <= i
        invariant 0 <= currentRun <= i - startIndex
        invariant startIndex >= 0
        invariant forall j :: 0 <= j < i ==> 
            if IsUpperCase(s[j]) then
                (j >= startIndex && j < startIndex + currentRun)
            else
                (j >= startIndex + currentRun)
        invariant maxRun >= currentRun
    {
        if IsUpperCase(s[i])
        {
            currentRun := currentRun + 1;
            if currentRun > maxRun {
                maxRun := currentRun;
            }
        }
        else
        {
            currentRun := 0;
            startIndex := i + 1;
        }
        i := i + 1;
    }
}