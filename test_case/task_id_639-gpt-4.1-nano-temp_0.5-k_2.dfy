method SumLengthsAfterFilter(names: seq<string>) returns (totalLength: int)
    requires names != null
    ensures totalLength == sum of |name| for all name in names where name[0] !in 'a'..'z'
{
    totalLength := 0;
    var i := 0;
    while i < |names|
        invariant 0 <= i <= |names|
        invariant totalLength == sum |names[j]| for j in 0..i-1 where names[j][0] !in 'a'..'z'
    {
        if |names[i]| > 0 && (names[i][0] in 'a'..'z') {
            // Skip names starting with lowercase letter
            i := i + 1;
        } else {
            totalLength := totalLength + |names[i]|;
            i := i + 1;
        }
    }
}