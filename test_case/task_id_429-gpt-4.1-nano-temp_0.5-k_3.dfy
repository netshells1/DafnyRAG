method ExtractElementAndSequence(seq1: seq<int>, seq2: seq<int>) returns (element: int, sequence: seq<int>)
    ensures seq1.Length > 0 ==> element == seq1[0]
    ensures sequence == seq2
{
    if seq1.Length > 0 {
        element := seq1[0];
    } else {
        // For empty seq1, assign a default value; since no precondition, choose 0
        element := 0;
    }
    sequence := seq2;
}