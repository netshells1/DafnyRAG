method ExtractElementwiseAndSequence(seq1: seq<int>, seq2: seq<int>) returns (elementwise: seq<(int, int)>, sequence: seq<seq<int>>)
    requires seq1 != null
    requires seq2 != null
    ensures elementwise == seq1.Zip(seq2)
    ensures sequence == seq1.SelectMany(x => [ [x] ]) + seq2.SelectMany(x => [ [x] ])
{
    // Build elementwise sequence as zipped pairs
    elementwise := seq1.Zip(seq2);
    // Build sequence of singleton sequences
    var seqs := [];
    var len := if seq1.Length < seq2.Length then seq1.Length else seq2.Length;
    var i := 0;
    while i < len
        invariant 0 <= i <= len
        invariant seqs == seq1.Take(i).Select(x => [x]) + seq2.Take(i).Select(x => [x])
    {
        seqs := seqs + [ [seq1[i]] ] + [ [seq2[i]] ];
        i := i + 1;
    }
    sequence := seqs;
}