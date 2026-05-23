predicate IsUpperCase(c: char)
{
    65 <= c as int <= 90
}

method MaxUppercaseRun(s: string) returns (maxRun: int, startIndex: int)
    ensures maxRun >= 0
    ensures 0 <= startIndex <= |s| - maxRun
    ensures forall i :: startIndex <= i < startIndex + maxRun ==> IsUpperCase(s[i])
    ensures forall i :: 0 <= i < |s| ==> (exists k :: startIndex <= k < startIndex + maxRun && i >= k && i < k + maxRun)
    ensures maxRun == if |s| == 0 then 0 else MaxSequenceLength(s)
{
    var currentLength := 0;
    var currentStart := 0;
    maxRun := 0;
    startIndex := 0;
    var i := 0;
    while i < |s|
        invariant 0 <= i <= |s|
        invariant currentLength >= 0
        invariant maxRun >= 0
        invariant (forall j :: 0 <= j < i ==> (isUppercase(s[j]) ==> (j >= currentStart && j < currentStart + currentLength)))
        invariant (forall j :: 0 <= j < i ==> (not isUppercase(s[j]) ==> true))
        invariant (maxRun >= currentLength)
        invariant (exists k :: startIndex <= k < startIndex + maxRun && (forall j :: startIndex <= j < startIndex + maxRun ==> IsUpperCase(s[j])))
    {
        if IsUpperCase(s[i]) {
            if currentLength == 0 {
                currentStart := i;
            }
            currentLength := currentLength + 1;
            if currentLength > maxRun {
                maxRun := currentLength;
                startIndex := currentStart;
            }
        } else {
            currentLength := 0;
        }
        i := i + 1;
    }
}

// Auxiliary function to compute maximum sequence length of uppercase characters in s
function MaxSequenceLength(s: string): int
    ensures MaxSequenceLength(s) >= 0
{
    if |s| == 0 then 0
    else
        var maxSeq := 0;
        var currentSeq := 0;
        var i := 0;
        while i < |s|
            invariant 0 <= i <= |s|
            invariant currentSeq >= 0
            invariant maxSeq >= 0
            invariant (forall j :: 0 <= j < i ==> (isUppercase(s[j]) ==> (j >= i - currentSeq && j < i)))
            invariant (maxSeq >= currentSeq)
        {
            if IsUpperCase(s[i]) {
                currentSeq := currentSeq + 1;
                if currentSeq > maxSeq {
                    maxSeq := currentSeq;
                }
            } else {
                currentSeq := 0;
            }
            i := i + 1;
        }
        maxSeq
    }
}