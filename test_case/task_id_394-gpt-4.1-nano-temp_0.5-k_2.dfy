method NoDuplicates(seq: seq<int>) returns (result: bool)
  ensures result <==> (forall i, j :: 0 <= i < j < |seq| ==> seq[i] != seq[j])
{
    result := true;
    var i := 0;
    while i < |seq|
        invariant 0 <= i <= |seq|
        invariant result <==> (forall x, y :: 0 <= x < y < i ==> seq[x] != seq[y])
    {
        var j := i + 1;
        while j < |seq|
            invariant i + 1 <= j <= |seq|
            invariant result <==> (forall x, y :: 0 <= x < y < i ==> seq[x] != seq[y]) &&
                        (forall x :: 0 <= x < i ==> seq[x] != seq[j])
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