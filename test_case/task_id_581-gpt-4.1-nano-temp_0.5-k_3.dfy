method PyramidSurfaceArea(baseEdge: int, height: int) returns (area: int)
    requires baseEdge > 0
    requires height > 0
    ensures area == baseEdge * baseEdge + 2 * baseEdge * slantHeight
{
    // Compute the approximate slant height squared
    var halfBase := baseEdge / 2;
    var slantHeightSquared := height * height + halfBase * halfBase;
    // Since Dafny cannot compute square roots directly, we can approximate slant height as an integer
    // For simplicity, take slantHeight as the integer square root of slantHeightSquared
    var slantHeight := if slantHeightSquared == 0 then 0 else
        // Implement integer square root (approximate)
        var low := 0;
        var high := slantHeightSquared;
        while low * low <= slantHeightSquared && (high + 1) * (high + 1) <= slantHeightSquared
            invariant 0 <= low <= high + 1
            invariant low * low <= slantHeightSquared
            invariant (high + 1) * (high + 1) > slantHeightSquared
        {
            var mid := (low + high + 1) / 2;
            if mid * mid <= slantHeightSquared {
                low := mid;
            } else {
                high := mid - 1;
            }
        }
        low;
    area := baseEdge * baseEdge + 2 * baseEdge * slantHeight;
}