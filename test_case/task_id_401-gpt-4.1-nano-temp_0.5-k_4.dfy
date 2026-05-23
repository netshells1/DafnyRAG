function ElementWiseAdd(s1: seq<int>, s2: seq<int>): seq<int>
    requires s1 != null && s2 != null
    requires s1.Length == s2.Length
    ensures result == [s1[k] + s2[k] | k :: 0 <= k < s1.Length]
{
    if s1.Length == 0 then
        []
    else
        [s1[0] + s2[0]] + ElementWiseAdd(s1[1..], s2[1..])
}

method IndexWiseAdd(seq1: seq<seq<int>>, seq2: seq<seq<int>>) returns (result: seq<seq<int>>)
    requires seq1 != null && seq2 != null
    requires seq1.Length == seq2.Length
    requires forall i :: 0 <= i < seq1.Length ==> seq1[i] != null && seq2[i] != null
    requires forall i :: 0 <= i < seq1.Length ==> seq1[i].Length == seq2[i].Length
    ensures result != null
    ensures result.Length == seq1.Length
    forall i :: 0 <= i < result.Length ==> result[i] == ElementWiseAdd(seq1[i], seq2[i])
{
    result := [];
    var i := 0;
    while i < seq1.Length
        invariant 0 <= i <= seq1.Length
        invariant result == [ for j := 0 to i-1 :: ElementWiseAdd(seq1[j], seq2[j]) ]
    {
        result := result + [ElementWiseAdd(seq1[i], seq2[i])];
        i := i + 1;
    }
}