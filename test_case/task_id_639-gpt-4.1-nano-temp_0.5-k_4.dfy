method SumLengthsOfNames(names: seq<string>) returns (totalLength: int)
    requires names != null
    ensures totalLength == sum i | 0 <= i < |names| :: if names[i][0] !in 'a'..'z' then |names[i]| else 0
{
    totalLength := 0;
    var i := 0;
    while i < |names|
        invariant 0 <= i <= |names|
        invariant totalLength == sum j | 0 <= j < i :: if names[j][0] !in 'a'..'z' then |names[j]| else 0
    {
        if |names[i]| > 0 && names[i][0] !in 'a'..'z' {
            totalLength := totalLength + |names[i]|;
        }
        i := i + 1;
    }
}