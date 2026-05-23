method DegreesToRadians(degrees: real) returns (radians: real)
    ensures radians == degrees * Pi / 180.0
{
    radians := degrees * Pi / 180.0;
}