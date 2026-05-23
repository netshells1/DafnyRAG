method RotateLeftBits(n: int, d: int) returns (r: int)
  requires 0 <= d <= 31
  requires -2147483648 <= n <= 2147483647
  ensures 0 <= r < 4294967296
  ensures r == ((n << d) | (n >> (32 - d))) & 0xFFFFFFFF
{
    // Since Dafny integers are unbounded, we simulate 32-bit unsigned behavior
    var shiftedLeft := (n << d) & 0xFFFFFFFF;
    var shiftedRight := (n >> (32 - d)) & 0xFFFFFFFF;
    r := (shiftedLeft | shiftedRight) & 0xFFFFFFFF;
}