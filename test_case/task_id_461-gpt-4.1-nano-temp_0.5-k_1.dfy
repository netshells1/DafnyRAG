predicate IsUpperCase(c: char)
{
    65 <= c as int <= 90
}

method CountUppercase(s: string) returns (count: int)
    ensures count >= 0
    ensures count == | set i: int | 0 <= i < |s| && IsUpperCase(s[i])|
{
    var uppercaseCount := 0;
    var i := 0;
    while i < |s|
        invariant 0 <= i <= |s|
        invariant uppercaseCount >= 0
        invariant uppercaseCount == | set k: int | 0 <= k < i && IsUpperCase(s[k]) |
    {
        if IsUpperCase(s[i]) {
            uppercaseCount := uppercaseCount + 1;
        }
        i := i + 1;
    }
    count := uppercaseCount;
}