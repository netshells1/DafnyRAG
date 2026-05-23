method RotateLeft(n: uint, d: int) returns (res: uint)
  requires 0 <= d < 32
  ensures 0 <= res < 4294967296
  ensures res == ((n << d) | (n >> (32 - d))) & 0xFFFFFFFF
{
    res := ((n << d) | (n >> (32 - d))) & 0xFFFFFFFF;
}