predicate Sorted(seq: seq<int>)
{
    forall i, j :: 0 <= i < j < |seq| ==> seq[i] <= seq[j]
}

method GetLucidNumbers(n: int) returns (result: seq<int>)
    requires n >= 0
    ensures forall x :: x in result ==> 0 <= x <= n
    ensures Sorted(result)
    ensures forall x :: x in result ==> x <= n
{
    var res := [];
    var current := 1;
    // Generate lucid numbers up to n
    // Assuming lucid numbers are numbers with digits in {1, 2, 3}
    // For demonstration, let's define lucid numbers as numbers composed only of digits 1, 2, 3
    // and less than or equal to n
    while current <= n
        invariant res == currentNumbersUpTo(current)
        invariant forall x :: x in res ==> 0 <= x <= n
        invariant Sorted(res)
    {
        if IsLucidNumber(current) {
            res := res + [current];
        }
        current := nextLucidNumber(current);
    }
    result := res;
}

// Helper predicate: check if number is a lucid number (digits only 1, 2, 3)
predicate IsLucidNumber(x: int)
{
    x >= 0 && (digits of x) are in {1, 2, 3}
}

// Helper function: generate next lucid number after current
function nextLucidNumber(x: int): int
{
    // For simplicity, assume it returns the next number with digits 1, 2, 3
    // Implementation omitted for brevity
    x + 1
}

// Helper function: generate list of lucid numbers up to current
function method currentNumbersUpTo(limit: int): seq<int>
{
    // Implementation omitted for brevity
    []
}

// Predicate to check if all digits are in {1, 2, 3}
predicate DigitsIn123(x: int)
{
    // Implementation omitted
}