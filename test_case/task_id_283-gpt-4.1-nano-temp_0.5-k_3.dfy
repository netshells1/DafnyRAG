method CheckDigitFrequencies(n: int) returns (result: bool)
  ensures result <==> (forall d: int :: 0 <= d <= 9 ==> CountDigitOccurrences(n, d) <= d)
{
    var absN := if n < 0 then -n else n;
    result := true;
    // For each digit d from 0 to 9, check if count(d) <= d
    var d := 0;
    while d <= 9
        invariant 0 <= d <= 10
        invariant result ==> forall dd: int :: 0 <= dd < d ==> CountDigitOccurrences(n, dd) <= dd
        invariant !result ==> exists dd: int :: 0 <= dd < d && CountDigitOccurrences(n, dd) > dd
    {
        if CountDigitOccurrences(n, d) > d {
            result := false;
            break;
        }
        d := d + 1;
    }
}

// Helper function to count occurrences of a digit in n
function CountDigitOccurrences(n: int, digit: int): int
  requires 0 <= digit <= 9
{
    var absN := if n < 0 then -n else n;
    CountDigitOccurrencesInNumber(absN, digit)
}

// Recursive helper function to count digit occurrences in a non-negative number
function CountDigitOccurrencesInNumber(num: int, digit: int): int
  requires num >= 0
{
    if num == 0 then
        if digit == 0 then 1 else 0
    else
        let lastDigit := num % 10;
        let rest := num / 10;
        (if lastDigit == digit then 1 else 0) + CountDigitOccurrencesInNumber(rest, digit)
}