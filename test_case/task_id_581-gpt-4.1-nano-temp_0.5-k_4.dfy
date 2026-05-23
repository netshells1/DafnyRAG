method PyramidSurfaceArea(baseEdge: int, height: int) returns (area: int)
    requires baseEdge > 0
    requires height > 0
    ensures area == baseEdge * baseEdge + 2 * baseEdge * slantHeight
{
    var halfBase := baseEdge / 2;
    var heightSquared := height * height;
    var halfBaseSquared := halfBase * halfBase;
    // Compute the squared slant height
    var slantHeightSquared := heightSquared + halfBaseSquared;
    // Since Dafny does not support floating point sqrt directly, approximate slant height as integer
    var slantHeight := SqrtInteger(slantHeightSquared);
    area := baseEdge * baseEdge + 2 * baseEdge * slantHeight;
}

// Helper function to compute integer square root
function method SqrtInteger(x: int): int
    requires x >= 0
{
    // Implement a simple integer square root using binary search
    var low := 0;
    var high := x + 1;
    while low < high
        invariant 0 <= low <= high
        invariant high * high >= x
        invariant low * low <= x
    {
        var mid := (low + high) / 2;
        if mid * mid > x {
            high := mid;
        } else {
            low := mid + 1;
        }
    }
    return low - 1;
}