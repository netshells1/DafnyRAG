predicate IsDigit(c: char)
{
    48 <= c as int <= 57
}

function method CountDigitOccurrences(n: int, d: int): int
{
    var s := n.ToString();
    |[ for c in s | c in s && IsDigit(c) && c as int - 48 == d :: 1 ]|
}

method CheckDigitFrequencies(n: int) returns (result: bool)
    ensures result <==> (forall d: int :: 0 <= d <= 9 ==> CountDigitOccurrences(n, d) <= d)
{
    var absN := if n >= 0 then n else -n;
    result := true;
    var s := absN.ToString();
    var counts := new int[10];
    // Count occurrences of each digit
    for c in s
        invariant 0 <= c as int - 48 < 10
        invariant 0 <= i <= |s|
        decreases |s| - i
        // Loop to count digits
        // (In Dafny, we can implement a counting loop if needed)
    {
        var d := c as int - 48;
        counts[d] := counts[d] + 1;
        // Advance index
        // For simplicity, we can process the string in a for loop
    }
    // Check the condition for all digits
    var allGood := true;
    for d := 0 to 9
        invariant 0 <= d <= 9
        invariant allGood ==> counts[d] <= d
        decreases 9 - d
    {
        if counts[d] > d {
            allGood := false;
        }
    }
    result := allGood;
}