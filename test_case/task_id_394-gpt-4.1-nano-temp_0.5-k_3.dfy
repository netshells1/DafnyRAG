method NoDuplicates(seq: seq<int>) returns (result: bool)
    ensures result <==> (forall x :: x in seq ==> CountOccurrences(seq, x) == 1)
{
    result := true;
    var seen := set<int>{};
    var i := 0;
    while i < |seq|
        invariant 0 <= i <= |seq|
        invariant result ==> (forall j :: 0 <= j < i ==> seq[j] !in seen)
        invariant seen == set s | s in seq[..i]
    {
        if seq[i] in seen {
            result := false;
            break;
        }
        seen := seen + {seq[i]};
        i := i + 1;
    }
}