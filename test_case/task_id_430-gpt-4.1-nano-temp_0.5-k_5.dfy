method FindDirectrix(vertexX: int, vertexY: int, focusY: int, p: int) returns (directrixY: int)
    requires p > 0
    requires focusY == vertexY + p
    ensures directrixY == vertexY - p
{
    // The directrix is located p units below the vertex
    directrixY := vertexY - p;
}