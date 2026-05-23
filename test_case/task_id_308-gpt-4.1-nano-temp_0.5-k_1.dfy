method FindTopProducts(a: array<int>, b: array<int>, count: nat) returns (results: seq<(int, int, int)>)
    requires a != null && b != null
    requires 0 < count <= a.Length * b.Length
    ensures |results| == count
    ensures forall i :: 0 <= i < |results| ==> 
        let (x, y, p) := results[i] in p == x * y
    ensures forall i, j :: 0 <= i < j < |results| ==> 
        let (_, _, p1) := results[i], (_, _, p2) := results[j] in p1 >= p2
{
    var pairs := new seq<(int, int, int)>(0);
    var i := 0;
    // Collect all pairs
    while i < a.Length
        invariant 0 <= i <= a.Length
        invariant |pairs| <= a.Length * b.Length
        invariant forall k :: 0 <= k < |pairs| ==> 
            let (x, y, p) := pairs[k] in p == x * y
    {
        var j := 0;
        while j < b.Length
            invariant 0 <= j <= b.Length
            invariant |pairs| <= a.Length * b.Length
            invariant forall k :: 0 <= k < |pairs| ==> 
                let (x, y, p) := pairs[k] in p == x * y
        {
            pairs := pairs + [(a[i], b[j], a[i] * b[j])];
            j := j + 1;
        }
        i := i + 1;
    }
    // Now select the top 'count' products
    var sortedPairs := pairs;
    // Sort descending by product
    sortedPairs := SortDescendingByProduct(sortedPairs);
    results := sortedPairs[..count];
}

// Helper function to sort pairs descending by product
function method SortDescendingByProduct(pairs: seq<(int, int, int)>): seq<(int, int, int)>
    decreases |pairs|
{
    // Simple insertion sort for clarity
    if |pairs| <= 1 then pairs
    else
        var head := pairs[0];
        var tail := pairs[1..];
        var sortedTail := SortDescendingByProduct(tail);
        InsertDescending(head, sortedTail)
}

function method InsertDescending(p: (int, int, int), seq: seq<(int, int, int)>): seq<(int, int, int)>
{
    if |seq| == 0 then [p]
    else if p[2] >= seq[0][2] then [p] + seq
    else [seq[0]] + InsertDescending(p, seq[1..])
}