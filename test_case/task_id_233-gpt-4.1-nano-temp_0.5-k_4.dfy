method CylinderLateralSurfaceArea(radius: int, height: int) returns (area: int)
  requires radius > 0
  requires height > 0
  ensures area == 2 * Math.PI * radius * height
{
    area := 2 * Math.PI * radius * height;
}