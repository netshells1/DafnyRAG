method ExtractElementwiseAndSequence(seq1: seq<int>, seq2: seq<int>) 
    returns (elementwise: seq<int>, sequence: seq<int>)
    requires true
    ensures |elementwise| == |seq1| && |elementwise| == |seq2| ==> forall i :: 0 <= i < |elementwise| ==> elementwise[i] == seq1[i] + seq2[i]
    ensures sequence == seq1 + seq2
{
    var res: seq<int> := [];
    var len := if |seq1| < |seq2| then |seq1| else |seq2|;
    var i := 0;
    while i < len
        invariant 0 <= i <= len
        invariant res == [for j := 0 to i - 1 :: seq1[j] + seq2[j]]
        invariant |res| == i
    {
        res := res + [seq1[i] + seq2[i]];
        i := i + 1;
    }
    // For remaining elements if sequences differ in length
    if |seq1| > len {
        sequence := res + seq1[len..];
    } else if |seq2| > len {
        sequence := res + seq2[len..];
    } else {
        sequence := res;
    }
    elementwise := [for j := 0 to |res| - 1 :: seq1[j] + seq2[j]];
}