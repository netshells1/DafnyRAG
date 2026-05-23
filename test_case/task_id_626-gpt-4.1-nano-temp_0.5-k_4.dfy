method LargestInscribedTriangleArea(radius: real) returns (area: real)
    requires radius > 0
    ensures area == (radius * radius) / 2
{
    // The maximum area of a triangle inscribed in a semicircle with radius r is (r^2)/2
    area := (radius * radius) / 2;
}