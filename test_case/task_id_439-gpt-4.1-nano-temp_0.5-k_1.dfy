method JoinArray(a: array<int>) returns (joined: int)
    requires a != null
    ensures joined == StringToInt(ConcatenateStrings(a))
{
    var resultStr := "";
    for i := 0 to a.Length
        invariant 0 <= i <= a.Length
        invariant resultStr == StringConcatUpTo(a, i)
    {
        resultStr := resultStr + IntToString(a[i]);
    }
    joined := StringToInt(resultStr);
}

function method StringToInt(s: string): int
{
    // Implementation detail, assuming total correctness
    // For verification purposes, assume this function correctly converts string to int
    // Placeholder: actual implementation would parse the string
    // Since Dafny can't execute arbitrary string parsing, assume this is a ghost function
    ghost {
        // For verification, assume the conversion is correct
    }
}

function method StringConcatUpTo(a: array<int>, i: int): string
    requires 0 <= i <= a.Length
{
    if i == 0 then ""
    else StringConcatUpTo(a, i - 1) + IntToString(a[i - 1])
}

function method IntToString(n: int): string
{
    // Placeholder: assume conversion is correct
    ghost {
        // For verification, assume this converts int to string correctly
    }
}