method NoDuplicates(seq: seq<int>) returns (result: bool)
  ensures result ==> (forall i, j :: 0 <= i < j < |seq| ==> seq[i] != seq[j])
  ensures !result ==> (exists i, j :: 0 <= i < j < |seq| && seq[i] == seq[j])
{
    result := true;
    var i := 0;
    while i < |seq|
        invariant 0 <= i <= |seq|
        invariant result ==> (forall k, l :: 0 <= k < l < i ==> seq[k] != seq[l])
        invariant !result ==> (exists k, l :: 0 <= k < l < i && seq[k] == seq[l])
    {
        var j := i + 1;
        while j < |seq|
            invariant i + 1 <= j <= |seq|
            invariant result ==> (forall m, n :: 0 <= m < n < i ==> seq[m] != seq[n])
            invariant !result ==> (exists m, n :: 0 <= m < n < i && seq[m] == seq[n]) || (exists m :: 0 <= m < i && seq[m] == seq[j])
        {
            if seq[i] == seq[j] {
                result := false;
                return;
            }
            j := j + 1;
        }
        i := i + 1;
    }
}