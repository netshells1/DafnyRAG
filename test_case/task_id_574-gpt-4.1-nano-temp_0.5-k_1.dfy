method CylinderSurfaceArea(radius: int, height: int) returns (area: int)
  requires radius > 0
  requires height > 0
  ensures area == 2.0 * 3.141592653589793 * radius * height + 2.0 * 3.141592653589793 * radius * radius
{
    // Approximate Pi as a constant
    const Pi := 3.141592653589793;
    area := 2.0 * Pi * radius * height + 2.0 * Pi * radius * radius;
}