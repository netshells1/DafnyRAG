method SphereSurfaceArea(radius: real) returns (area: real)
    requires radius > 0
    ensures area == 4.0 * pi * radius * radius
{
    area := 4.0 * pi * radius * radius;
}