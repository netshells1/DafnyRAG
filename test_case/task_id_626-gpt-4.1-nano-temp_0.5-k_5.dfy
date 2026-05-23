method LargestInscribedTriangleArea(radius: real) returns (area: real)
  requires radius > 0
  ensures area == radius * radius
{
    // The largest inscribed triangle in a semicircle is an isosceles right triangle
    // with vertices at the endpoints of the diameter and the highest point on the semicircle
    // Its area is (1/2) * radius * radius
    area := radius * radius;
}