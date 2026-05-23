method DegreesToRadians(degrees: real) returns (radians: real)
  ensures radians == degrees * Math.PI / 180.0
{
    radians := degrees * Math.PI / 180.0;
}