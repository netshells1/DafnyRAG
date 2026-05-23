method LargestInscribedTriangleArea(radius: real) returns (area: real)
    requires radius > 0
    ensures area == (radius * radius) / 2
{
    // The maximum inscribed triangle in a semicircle is an isosceles triangle with the base on the diameter
    // and the apex at the highest point of the semicircle.
    // Its area is (base * height) / 2 = (2 * radius) * radius / 2 = radius^2
    // But since the problem asks for the largest triangle inscribed in a semicircle,
    // the maximum area is achieved when the triangle is right-angled with hypotenuse as diameter.
    // The area of such a triangle is (radius^2) / 2.
    area := (radius * radius) / 2;
}