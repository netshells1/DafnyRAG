method FindDirectrix(a: real, b: real, c: real, p: real) returns (directrix: real)
    requires a != 0
    requires p > 0
    ensures directrix == (-b / (2.0 * a)) - p
{
    // Calculate the vertex's y-coordinate
    var vertexY := -b / (2.0 * a);
    // The directrix is p units below the vertex
    directrix := vertexY - p;
}