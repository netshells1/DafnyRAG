method MedianOfThree(a: int, b: int, c: int) returns (median: int)
    ensures median == a || median == b || median == c
    ensures min(a, b, c) <= median <= max(a, b, c)
{
    // Determine the median by comparing the numbers
    if (a <= b) {
        if (b <= c) {
            median := b; // a <= b <= c
        } else if (a <= c) {
            median := c; // a <= c < b
        } else {
            median := a; // c < a <= b
        }
    } else {
        if (a <= c) {
            median := a; // b < a <= c
        } else if (b <= c) {
            median := c; // b <= c < a
        } else {
            median := b; // c < b < a
        }
    }
}