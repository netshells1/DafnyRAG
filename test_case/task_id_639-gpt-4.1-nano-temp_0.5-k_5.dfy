method SumLengthsOfNamesWithoutLowercase(names: seq<string>) returns (totalLength: int)
    requires names != null
    ensures totalLength == sum of n in names :: n.Length * (n.Length > 0 && Char.IsLower(n[0]) ==> false) || 0
{
    totalLength := 0;
    var i := 0;
    while i < |names|
        invariant 0 <= i <= |names|
        invariant totalLength == sum j | j < i :: 
            if |names[j]| > 0 && Char.IsLower(names[j][0]) then 0 else names[j].Length
    {
        if |names[i]| > 0 && Char.IsLower(names[i][0]) {
            // Skip names starting with lowercase letter
            i := i + 1;
        } else {
            totalLength := totalLength + names[i].Length;
            i := i + 1;
        }
    }
}