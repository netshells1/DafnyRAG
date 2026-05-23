method CylinderVolume(radius: int, height: int) returns (volume: int)
  requires radius > 0
  requires height > 0
  ensures volume == 3 * radius * radius * height
{
    volume := 3 * radius * radius * height;
}