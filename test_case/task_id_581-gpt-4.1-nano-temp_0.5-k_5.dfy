method PyramidSurfaceArea(baseEdge: int, height: int) returns (area: real)
  requires baseEdge > 0
  requires height > 0
  ensures area == (baseEdge * baseEdge) + 2.0 * baseEdge * sqrt( (baseEdge/2.0)*(baseEdge/2.0) + height * height )
{
    var baseArea := baseEdge * baseEdge;
    var slantHeight := sqrt( (baseEdge/2.0)*(baseEdge/2.0) + height * height );
    area := baseArea + 2.0 * baseEdge * slantHeight;
}