method RotateLeftBits(n: uint, d: int) returns (res: uint)
  requires 0 <= d <= 31
  ensures 0 <= res <= 0xFFFFFFFF
  ensures res == (n << d) | (n >> (32 - d))
{
    res := (n << d) | (n >> (32 - d));
}