method CountMatchingPositions(a: seq<int>, b: seq<int>, c: seq<int>) returns (count: int)
    ensures count == |{ i :: 0 <= i < |a| && a[i] == b[i] && b[i] == c[i] }|
{
    // The sequences should be of the same length for position-wise comparison
    // To simplify, we assume sequences are of equal length; if not, compare up to the minimum length
    var minLen := if |a| <= |b| then if |a| <= |c| then |a| else |c| else if |b| <= |c| then |b| else |c|;
    count := 0;
    var i := 0;
    while i < minLen
        invariant 0 <= i <= minLen
        invariant count == |{ j :: 0 <= j < i && a[j] == b[j] && b[j] == c[j] }|
    {
        if a[i] == b[i] && b[i] == c[i] {
            count := count + 1;
        }
        i := i + 1;
    }
}