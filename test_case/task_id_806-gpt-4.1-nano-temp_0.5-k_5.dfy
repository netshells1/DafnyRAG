predicate IsUpperCase(c: char)
{
    65 <= c as int <= 90
}

method MaxUppercaseRun(s: string) returns (maxRun: int, startIndex: int)
    ensures maxRun >= 0
    ensures 0 <= startIndex <= |s| - maxRun
    ensures forall i :: 0 <= i < |s| - maxRun + 1 ==> 
                (exists k :: 0 <= k < maxRun && forall j :: startIndex <= j < startIndex + maxRun ==> s[j] is uppercase)
                && (for all j in [startIndex, startIndex + maxRun), s[j] is uppercase)
                && (maxRun == 0 ==> true)
    ensures maxRun > 0 ==> 
                (forall j :: startIndex <= j < startIndex + maxRun ==> s[j] is uppercase)
    ensures (maxRun > 0) ==> 
                (forall i :: 0 <= i < startIndex ==> s[i] is not uppercase) 
                && (forall i :: startIndex + maxRun <= i < |s| ==> s[i] is not uppercase)
{
    maxRun := 0;
    startIndex := 0;
    var currentCount := 0;
    var currentStart := 0;
    var i := 0;
    while i < |s|
        invariant 0 <= i <= |s|
        invariant maxRun >= 0
        invariant 0 <= startIndex <= |s| - maxRun
        invariant currentCount >= 0
        invariant currentStart >= 0
        invariant forall j :: currentStart <= j < i ==> 
                    (s[j] is uppercase) && (j < currentStart + currentCount)
        invariant forall j :: 0 <= j < startIndex ==> s[j] is not uppercase
        invariant forall j :: startIndex + maxRun <= j < |s| ==> s[j] is not uppercase
        invariant (currentCount <= maxRun)
    {
        if s[i] is uppercase {
            if currentCount == 0 {
                currentStart := i;
            }
            currentCount := currentCount + 1;
            if currentCount > maxRun {
                maxRun := currentCount;
                startIndex := currentStart;
            }
        } else {
            currentCount := 0;
        }
        i := i + 1;
    }
}