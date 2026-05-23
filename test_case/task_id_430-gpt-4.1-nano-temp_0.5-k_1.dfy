method FindDirectrix(a: real, b: real, c: real) returns (directrix: real)
    requires a != 0
    ensures directrix == - (b * b) / (4.0 * a) - 1.0 / (4.0 * a)
{
    // The directrix line y = k - 1/(4a), where k is the vertex y-coordinate
    // Vertex y-coordinate: y_vertex = - (b^2) / (4a) + c
    var y_vertex := - (b * b) / (4.0 * a) + c;
    directrix := y_vertex - 1.0 / (4.0 * a);
}