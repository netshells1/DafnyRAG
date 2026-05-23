method ConeVolume(radius: real, height: real) returns (volume: real)
    requires radius > 0
    requires height > 0
    ensures volume == (1.0/3.0) * Pi * radius * radius * height
{
    volume := (1.0/3.0) * Pi * radius * radius * height;
}