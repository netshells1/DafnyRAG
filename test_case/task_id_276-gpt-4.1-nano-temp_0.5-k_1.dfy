method CylinderVolume(radius: real, height: real) returns (volume: real)
  requires radius > 0. && height > 0.
  ensures volume == Pi * radius * radius * height
{
    volume := Pi * radius * radius * height;
}