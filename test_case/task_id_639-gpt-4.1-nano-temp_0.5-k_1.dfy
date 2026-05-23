method SumLengthOfNamesAfterFiltering(names: seq<string>) returns (totalLength: int)
    requires names != null
    ensures totalLength >= 0
    ensures totalLength == sum of |name| for all name in names where name[0] !in {'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'}
{
    totalLength := 0;
    var i := 0;
    while i < |names|
        invariant 0 <= i <= |names|
        invariant totalLength >= 0
        invariant totalLength == sum |names[j]| for j in 0..i-1 where names[j][0] !in {'a', ..., 'z'}
    {
        if |names[i]| > 0 && names[i][0] !in {'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'} {
            totalLength := totalLength + |names[i]|;
        }
        i := i + 1;
    }
}