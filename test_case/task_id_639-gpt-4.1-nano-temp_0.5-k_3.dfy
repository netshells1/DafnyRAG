method SumLengthsOfNamesAfterRemovingLowercase(names: seq<string>) returns (totalLength: int)
    requires names != null
    ensures totalLength >= 0
    ensures totalLength == 
        if |names| == 0 then 0
        else
            // Sum of lengths of names not starting with lowercase
            sum [ |names[i]| | i | 0 <= i < |names| && (names[i])[0] !in 'a'..'z' ]
{
    totalLength := 0;
    var i := 0;
    while i < |names|
        invariant 0 <= i <= |names|
        invariant totalLength >= 0
        invariant totalLength == sum [ |names[j]| | j | 0 <= j < i && (names[j])[0] !in 'a'..'z' ]
    {
        if |names[i]| > 0 && (names[i])[0] !in 'a'..'z' {
            totalLength := totalLength + |names[i]|;
        }
        i := i + 1;
    }
}