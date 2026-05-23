method PairwiseAdd(s: seq<int>) returns (result: seq<int>)
  ensures |result| == if |s| > 0 then |s| - 1 else 0
  ensures forall i :: 0 <= i < |result| ==> result[i] == s[i] + s[i + 1]
{
    var r := [];
    var n := |s|;
    var i := 0;
    while i < n - 1
        invariant 0 <= i <= n
        invariant |r| == i
        invariant forall j :: 0 <= j < i ==> r[j] == s[j] + s[j + 1]
    {
        r := r + [s[i] + s[i + 1]];
        i := i + 1;
    }
    result := r;
}