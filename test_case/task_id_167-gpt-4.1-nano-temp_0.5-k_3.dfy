method NextPowerOfTwo(n: int) returns (p: int)
  requires n >= 0
  ensures p >= n
  ensures exists k: int :: p == 1 << k
  ensures p < 2 * n + 1
{
    p := 1;
    while p < n
        invariant p >= 1
        invariant p >= n ==> p == 1 << (ceil_log2(n))
        invariant p >= n
    {
        p := p * 2;
    }
}