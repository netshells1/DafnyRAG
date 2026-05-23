method AppendArrayToSequence(a: array<int>, s: seq<int>) returns (result: seq<int>)
    ensures result == s + a[..]
{
    var res := s;
    var i := 0;
    while i < a.Length
        invariant 0 <= i <= a.Length
        invariant res == s + a[..i]
    {
        res := res + [a[i]];
        i := i + 1;
    }
    result := res;
}