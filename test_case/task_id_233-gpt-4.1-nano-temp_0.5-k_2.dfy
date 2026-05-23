method CylinderLateralSurfaceArea(radius: real, height: real) returns (area: real)
    requires radius > 0
    requires height > 0
    ensures area == 2.0 * Pi * radius * height
{
    area := 2.0 * Pi * radius * height;
}