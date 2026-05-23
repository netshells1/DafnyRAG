method MinSublistLength(main: seq<int>) returns (length: nat)
    ensures length >= 0
    ensures exists i, j :: 0 <= i <= j <= |main| && main[i..j] == main[i..j] && (j - i) == length
{
    var minLen := |main| + 1;
    var i := 0;
    while i <= |main|
        invariant 0 <= i <= |main| + 1
        invariant minLen >= 0
        invariant forall i', j' :: 0 <= i' <= j' <= i ==> (j' - i') >= minLen
    {
        var j := i;
        while j <= |main|
            invariant i <= j <= |main| + 1
            invariant minLen >= 0
            if (j - i) < minLen
                minLen := j - i;
            j := j + 1;
        i := i + 1;
    }
    length := minLen;
}