method PyramidSurfaceArea(baseEdge: int, height: int) returns (area: int)
  requires baseEdge > 0
  requires height > 0
  ensures area == baseEdge * baseEdge + 2 * baseEdge * slantHeight
  where
    var slantHeight := sqrt((baseEdge as real / 2.0) * (baseEdge as real / 2.0) + height * height);
{
    var slantHeight := sqrt((baseEdge as real / 2.0) * (baseEdge as real / 2.0) + height * height);
    area := baseEdge * baseEdge + 2 * baseEdge * slantHeight;
}