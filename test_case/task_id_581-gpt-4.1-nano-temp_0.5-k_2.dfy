method PyramidSurfaceArea(baseEdge: int, height: int) returns (area: int)
  requires baseEdge > 0
  requires height > 0
  ensures area == baseArea + lateralArea
    where {
      baseArea == baseEdge * baseEdge
      slantHeight == ((baseEdge as real / 2.0) * (baseEdge as real / 2.0) + height * height) ^ 0.5
      lateralArea == 2.0 * baseEdge as real * slantHeight
    }
{
    var baseArea := baseEdge * baseEdge;
    var slantHeight := ((baseEdge as real / 2.0) * (baseEdge as real / 2.0) + height * height) ^ 0.5;
    var lateralArea := 2.0 * baseEdge as real * slantHeight;
    area := baseArea + lateralArea as int; // approximate casting
}