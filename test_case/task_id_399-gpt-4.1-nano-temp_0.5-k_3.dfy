method BitwiseXorSeqs(a: seq<bv>, b: seq<bv>) returns (result: seq<bv>)
    requires a != null && b != null
    requires a.Length == b.Length
    ensures result != null
    ensures result.Length == a.Length
    ensures forall i :: 0 <= i < result.Length ==> result[i] == a[i] ^ b[i]
{
    result := [];
    var i := 0;
    while i < a.Length
        invariant 0 <= i <= a.Length
        invariant result == [ for k := 0 to i - 1 :: a[k] ^ b[k] ]
        invariant result.Length == i
    {
        result := result + [a[i] ^ b[i]];
        i := i + 1;
    }
}