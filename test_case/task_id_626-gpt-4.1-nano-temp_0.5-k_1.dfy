method LargestInscribedTriangleArea(radius: real) returns (area: real)
    requires radius > 0
    ensures area == (radius * radius) / 2
{
    // The largest inscribed triangle in a semicircle is an isosceles right triangle
    // with its base lying along the diameter, and the apex at the highest point of the semicircle.
    // Its area is (1/2) * base * height = (1/2) * (2 * radius) * radius = radius * radius.
    // But since the triangle is inscribed in a semicircle, the maximum area is achieved when the triangle
    // is right-angled with hypotenuse on the diameter, and the height equal to radius.
    // The maximum area is therefore (radius * radius) / 2.
    area := (radius * radius) / 2.0;
}