method SphereVolume(radius: real) returns (volume: real)
    requires radius > 0
    ensures volume == (4.0 / 3.0) * Pi * radius * radius * radius
{
    volume := (4.0 / 3.0) * Pi * radius * radius * radius;
}