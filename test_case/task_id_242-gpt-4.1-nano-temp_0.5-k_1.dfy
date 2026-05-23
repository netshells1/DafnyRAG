method CountCharacters(s: string) returns (count: int)
    ensures count == |s|
{
    count := 0;
    var i := 0;
    while i < |s|
        invariant 0 <= i <= |s|
        invariant count == i
    {
        i := i + 1;
        count := i;
    }
}