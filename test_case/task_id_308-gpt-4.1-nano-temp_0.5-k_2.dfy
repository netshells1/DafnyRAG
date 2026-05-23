method TopKProducts(a: array<int>, b: array<int>, k: nat) returns (result: seq<int>)
    requires a != null && b != null
    requires a.Length > 0 && b.Length > 0
    requires 0 < k <= a.Length * b.Length
    ensures |result| == k
    ensures forall i :: 0 <= i < |result| ==> exists x, y :: x in a && y in b && result[i] == x * y
    ensures forall i, j :: 0 <= i < j < |result| ==> result[i] >= result[j]
{
    var products := new seq<int>();
    // Generate all possible products
    for i := 0 to a.Length - 1
        invariant 0 <= i <= a.Length
        invariant products == (seq for x in a[0..i] :: seq for y in b :: x * y)
    {
        for j := 0 to b.Length - 1
            invariant 0 <= j <= b.Length
            invariant products == (seq for x in a[0..i] :: seq for y in b[0..j] :: x * y)
        {
            products := products + [a[i] * b[j]];
        }
    }
    // Now, select the top k products
    var sorted := SeqSortDescending(products);
    result := sorted[..k];
}

function SeqSortDescending(s: seq<int>): seq<int>
{
    if |s| <= 1 then s
    else
        var pivot := s[0];
        var less := SeqSortDescending([x | x in s[1..] :: x > pivot]);
        var greater := SeqSortDescending([x | x in s[1..] :: x <= pivot]);
        greater + [pivot] + less
}