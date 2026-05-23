method AllElementsInSecondSmallerThanFirst(seq1: seq<int>, seq2: seq<int>) returns (result: bool)
  requires |seq1| == |seq2|
  ensures result <==> forall i :: 0 <= i < |seq1| ==> seq2[i] < seq1[i]
{
    result := true;
    var i := 0;
    while i < |seq1|
        invariant 0 <= i <= |seq1|
        invariant result ==> forall k :: 0 <= k < i ==> seq2[k] < seq1[k]
        invariant !result ==> exists k :: 0 <= k < i && seq2[k] >= seq1[k]
    {
        if seq2[i] >= seq1[i] {
            result := false;
            break;
        }
        i := i + 1;
    }
}