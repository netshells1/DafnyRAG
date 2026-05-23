method CircleCircumference(radius: real) returns (circumference: real)
  requires radius >= 0
  ensures circumference == 2.0 * pi * radius
{
    circumference := 2.0 * pi * radius;
}