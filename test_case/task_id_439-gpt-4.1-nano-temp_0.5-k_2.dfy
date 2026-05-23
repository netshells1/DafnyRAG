function method Concatenate(a: array<int>): int
  requires a != null
  decreases a
{
    var res := 0;
    var factor := 1;
    // Process from the end to the start to build the concatenation
    for i := a.Length - 1 to 0
        invariant 0 <= i < a.Length
        invariant res == ConcatenatePrefix(a, i + 1)
        invariant factor > 0
    {
        var numDigits := NumDigits(a[i]);
        res := a[i] * factor + res;
        factor := factor * Pow(10, numDigits);
    }
    res
}

function method NumDigits(n: int): int
{
    if n == 0 then 1 else 1 + NumDigits(n / 10)
}

function method Pow(base: int, exp: int): int
{
    if exp == 0 then 1 else base * Pow(base, exp - 1)
}

function method ConcatenatePrefix(a: array<int>, start: int): int
  requires 0 <= start <= a.Length
{
    var res := 0;
    for i := start to a.Length - 1
        invariant start <= i < a.Length
        invariant res == ConcatenatePrefix(a, i + 1)
    {
        var numDigits := NumDigits(a[i]);
        res := res * Pow(10, numDigits) + a[i];
    }
    res
}

method JoinArray(a: array<int>) returns (result: int)
  requires a != null
  ensures result == Concatenate(a)
{
    result := Concatenate(a);
}