method MaxLengthList(lists: seq<seq<int>>) returns (maxList: seq<int>)
    ensures |maxList| == if |lists| == 0 then 0 else MaxLength(lists)
    ensures exists l :: l in lists && l == maxList
{
    var maxLen := 0;
    var candidate: seq<int> := [];

    // Iterate over all lists to find the maximum length
    for l in lists
        invariant 0 <= |l| <= |lists| // Since |l| is length of current list
        invariant maxLen >= 0
        invariant maxLen >= |candidate|
        invariant (exists l2 :: l2 in lists && |l2| == maxLen)
    {
        if |l| > maxLen {
            maxLen := |l|;
            candidate := l;
        }
    }
    maxList := candidate;
}

// Auxiliary function to compute maximum length among a sequence of sequences
function MaxLength(seqOfSeqs: seq<seq<int>>): int
{
    if |seqOfSeqs| == 0 then 0
    else
        var maxRest := MaxLength(seqOfSeqs[1..]);
        if |seqOfSeqs[0]| > maxRest then |seqOfSeqs[0]| else maxRest
}