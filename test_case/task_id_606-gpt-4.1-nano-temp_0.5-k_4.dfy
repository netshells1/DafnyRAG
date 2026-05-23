method DegreesToRadians(degrees: real) returns (radians: real)
  ensures radians == degrees * pi / 180.0
{
    radians := degrees * pi / 180.0;
}