method SphereSurfaceArea(radius: real) returns (area: real)
    requires radius > 0
    ensures area == 4.0 * Math.Pi * radius * radius
{
    area := 4.0 * Math.Pi * radius * radius;
}