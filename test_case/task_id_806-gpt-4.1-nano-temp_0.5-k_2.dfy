predicate IsUppercase(c: char)
{
    65 <= c as int <= 90
}

method MaxUpperRun(s: string) returns (maxRun: int)
    ensures maxRun >= 0
    ensures exists start :: 0 <= start <= |s| - maxRun && (forall k :: start <= k < start + maxRun ==> s[k] is uppercase) &&
            (forall i :: 0 <= i <= |s| - maxRun ==> 
                (exists j :: 0 <= j <= |s| - maxRun && (forall k :: j <= k < j + maxRun ==> s[k] is uppercase) && j <= i))
{
    var currentRun := 0;
    maxRun := 0;
    var i := 0;
    while i < |s|
        invariant 0 <= i <= |s|
        invariant maxRun >= 0
        invariant currentRun >= 0
        invariant maxRun >= currentRun
        invariant forall start :: 0 <= start <= i && (forall k :: start <= k < start + currentRun ==> s[k] is uppercase) ==> start <= i - currentRun
    {
        if s[i] is uppercase {
            currentRun := currentRun + 1;
            if currentRun > maxRun {
                maxRun := currentRun;
            }
        } else {
            currentRun := 0;
        }
        i := i + 1;
    }
}