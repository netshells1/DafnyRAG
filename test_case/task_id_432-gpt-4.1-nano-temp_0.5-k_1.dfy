method MedianTrapeziumLength(a: int, b: int, c: int, d: int) returns (median: int)
    ensures exists sortedList :: sortedList == sort([a, b, c, d]) && median == sortedList[1]
{
    var lst := [a, b, c, d];
    var sortedList := sort(lst);
    median := sortedList[1]; // second element in sorted list (middle for even count)
}