method FindDirectrix(a: real, b: real, c: real, focusX: real, focusY: real) returns (directrixY: real)
    requires a != 0
    requires focusY == a * focusX * focusX + b * focusX + c
    ensures (a > 0) ==> directrixY == focusY - 1 / (4 * a)
    ensures (a < 0) ==> directrixY == focusY + 1 / (4 * a)
{
    if a > 0 {
        directrixY := focusY - 1.0 / (4.0 * a);
    } else {
        directrixY := focusY + 1.0 / (4.0 * a);
    }
}