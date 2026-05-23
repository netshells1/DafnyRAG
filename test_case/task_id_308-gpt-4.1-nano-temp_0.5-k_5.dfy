method LargestProducts(a: array<int>, b: array<int>, count: int) returns (results: seq<(int, int, int)>)
    requires a != null && b != null
    requires 0 <= count <= a.Length * b.Length
    ensures results != null
    ensures |results| == count
    ensures forall k :: 0 <= k < |results| ==> results[k] == (a_element, b_element, a_element * b_element)
    ensures results is sorted descending by third component (product)
{
    // Generate all pairs with their products
    var pairs := new seq<(int, int, int)>(0);
    var i := 0;
    while i < a.Length
        invariant 0 <= i <= a.Length
        invariant pairs != null
        invariant |pairs| == i * b.Length
    {
        var j := 0;
        while j < b.Length
            invariant 0 <= j <= b.Length
            invariant pairs != null
            invariant |pairs| == i * b.Length + j
        {
            pairs := pairs + [(a[i], b[j], a[i] * b[j])];
            j := j + 1;
        }
        i := i + 1;
    }
    // Sort pairs in descending order by product
    var sortedPairs := SortDescending(pairs);
    // Take the first 'count' elements
    results := sortedPairs[..count];
}

// Helper function to sort sequence of triples descending by product
function method SortDescending(seq: seq<(int, int, int)>): seq<(int, int, int)>
    decreases |seq|
{
    if |seq| <= 1 then seq
    else
        var mid := |seq| / 2;
        var left := SortDescending(seq[..mid]);
        var right := SortDescending(seq[mid..]);
        MergeDescending(left, right)
}

// Merge two sorted sequences into one sorted sequence descending by third component
function method MergeDescending(left: seq<(int, int, int)>, right: seq<(int, int, int)>): seq<(int, int, int)>
    decreases |left| + |right|
{
    if |left| == 0 then right
    else if |right| == 0 then left
    else
        if left[0].2 >= right[0].2 then
            [left[0]] + MergeDescending(left[1..], right)
        else
            [right[0]] + MergeDescending(left, right[1..])
}