method MedianOfThree(a: int, b: int, c: int) returns (median: int)
    ensures (median == a || median == b || median == c)
    ensures ( (a <= median && median <= b) || (b <= median && median <= a) )
    ensures ( (a <= median && median <= c) || (c <= median && median <= a) )
    ensures ( (b <= median && median <= c) || (c <= median && median <= b) )
{
    if (a >= b) {
        if (a <= c) {
            median := a;
        } else if (b >= c) {
            median := b;
        } else {
            median := c;
        }
    } else {
        if (b <= c) {
            median := b;
        } else if (a >= c) {
            median := a;
        } else {
            median := c;
        }
    }
}