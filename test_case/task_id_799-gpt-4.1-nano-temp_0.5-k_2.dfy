method RotateLeftBits(n: int, d: int) returns (r: int)
  requires 0 <= n < 4294967296
  requires 0 <= d < 32
  ensures 0 <= r < 4294967296
  ensures r == ((n << d) | (n >> (32 - d))) & 0xFFFFFFFF
{
    r := ((n << d) | (n >> (32 - d))) & 0xFFFFFFFF;
}