method CircleCircumference(radius: real) returns (circumference: real)
    requires radius >= 0.0
    ensures circumference == 2.0 * Pi * radius
{
    circumference := 2.0 * Pi * radius;
}