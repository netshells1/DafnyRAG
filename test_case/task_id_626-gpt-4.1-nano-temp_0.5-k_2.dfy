method LargestInscribedTriangleArea(radius: real) returns (area: real)
    requires radius > 0
    ensures area == (radius * radius) / 2
{
    // The largest inscribed triangle in a semicircle is an isosceles right triangle
    // with base and height equal to radius, leading to maximum area = (radius * radius) / 2
    area := (radius * radius) / 2.0;
}