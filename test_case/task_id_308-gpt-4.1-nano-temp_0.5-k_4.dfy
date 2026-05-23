method TopKProducts(a: array<int>, b: array<int>, k: nat) returns (result: seq<int>)
    requires a != null && b != null
    requires 0 < k <= a.Length * b.Length
    ensures |result| <= k
    ensures forall i :: 0 <= i < |result| - 1 ==> result[i] >= result[i + 1]
    ensures forall i :: 0 <= i < |result| ==> exists x, y :: x in a && y in b && result[i] == x * y
{
    var pairs: seq<(int, int, int)> := [];
    // Generate all pairs with their products
    for i := 0 to a.Length - 1
        invariant 0 <= i <= a.Length
        invariant forall j :: 0 <= j < i ==> true // no specific invariant needed here
    {
        for j := 0 to b.Length - 1
            invariant 0 <= j <= b.Length
            invariant forall m :: 0 <= m < i * b.Length + j ==> true // no specific invariant
        {
            pairs := pairs + [(a[i], b[j], a[i] * b[j])];
        }
    }
    // Sort pairs by product in descending order
    var sortedPairs := SortDescending(pairs);
    // Take top k products
    result := seq[ p[2] | p <- sortedPairs ][0 .. k - 1];
}

// Helper function to sort sequence of triples by the third element in descending order
function method SortDescending(pairs: seq<(int, int, int)>): seq<(int, int, int)>
    decreases |pairs|
{
    if |pairs| <= 1 then pairs
    else
    {
        var pivot := pairs[0];
        var less := [ p | p <- pairs[1..], p[2] >= pivot[2] ];
        var greater := [ p | p <- pairs[1..], p[2] < pivot[2] ];
        SortDescending(greater) + [pivot] + SortDescending(less)
    }
}