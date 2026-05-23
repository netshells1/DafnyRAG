method RotateLeftBits(n: int, d: int) returns (res: int)
  requires 0 <= n < 4294967296
  requires 0 <= d < 32
  ensures 0 <= res < 4294967296
  ensures res == ((n << d) | (n >> (32 - d))) & 0xFFFFFFFF
{
    var shiftedLeft := (n << d);
    var shiftedRight := (n >> (32 - d));
    res := (shiftedLeft | shiftedRight) & 0xFFFFFFFF;
}