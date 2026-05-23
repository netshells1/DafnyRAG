// Predicate to define that s is a contiguous sublist of main
predicate IsSublistOf(s: seq<int>, main: seq<int>)
{
    exists i, j :: 0 <= i <= j <= |main| && s == main[i..j]
}

method FindMinimalSublist(main: seq<int>) returns (sub: seq<int>)
    ensures IsSublistOf(sub, main)
    ensures forall s :: IsSublistOf(s, main) ==> |s| >= |sub|
{
    var minLength := |main| + 1;
    var minSub := [];

    // Iterate over all possible sublists
    var i := 0;
    while i <= |main|
        invariant 0 <= i <= |main| + 1
        invariant minLength <= |main| + 1
        invariant minSub in main
        invariant (forall s :: IsSublistOf(s, main) ==> |s| >= |minSub|)
    {
        var j := i;
        while j <= |main|
            invariant i <= j <= |main| + 1
            invariant minLength <= |main| + 1
            invariant minSub in main
            invariant (forall s :: IsSublistOf(s, main) ==> |s| >= |minSub|)
        {
            var candidate := main[i..j];
            if |candidate| < minLength {
                minLength := |candidate|;
                minSub := candidate;
            }
            j := j + 1;
        }
        i := i + 1;
    }
    sub := minSub;
}