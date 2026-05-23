method PerimeterOfPentagon(sideLength: int) returns (perimeter: int)
    requires sideLength > 0
    ensures perimeter == 5 * sideLength
{
    perimeter := 5 * sideLength;
}