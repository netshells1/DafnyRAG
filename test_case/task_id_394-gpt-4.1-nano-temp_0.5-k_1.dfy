method NoDuplicates(seq: seq<int>) returns (result: bool)
    ensures result <==> (forall i, j :: 0 <= i < j < |seq| ==> seq[i] != seq[j])
{
    result := true;
    var i := 0;
    while i < |seq|
        invariant 0 <= i <= |seq|
        invariant result ==> (forall k, l :: 0 <= k < l < i ==> seq[k] != seq[l])
        decreases |seq| - i
    {
        var j := i + 1;
        while j < |seq|
            invariant i <= j <= |seq|
            invariant result ==> (forall k, l :: 0 <= k < l < i ==> seq[k] != seq[l])
            invariant result ==> (forall k :: 0 <= k < i ==> forall m :: i <= m < j ==> seq[k] != seq[m])
            decreases |seq| - j
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