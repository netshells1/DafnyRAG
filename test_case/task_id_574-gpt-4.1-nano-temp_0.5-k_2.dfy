method CylinderSurfaceArea(radius: int, height: int) returns (area: int)
    requires radius > 0
    requires height > 0
    ensures area == 2 * 3 * radius * radius + 2 * 3 * radius * height
{
    area := 2 * 3 * radius * radius + 2 * 3 * radius * height;
}