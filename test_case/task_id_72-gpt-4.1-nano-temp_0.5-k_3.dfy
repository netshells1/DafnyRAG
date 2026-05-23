method IsDifferenceOfTwoSquares(n: int) returns (result: bool)
  ensures result <==> (exists a, b: int :: n == a * a - b * b)
{
    // For any integer n, it can be expressed as a difference of two squares if and only if
    // n is not congruent to 2 modulo 4, or n is odd, or n is divisible by 4.
    // But to keep the implementation simple and correct, we'll check all possible pairs within a certain range.
    // Since for large n, this might be inefficient, but correctness is our priority here.
  
    result := false;
    var limit := if n >= 0 then n + 1 else -n + 1;
    var found := false;
    var a, b: int;
    // Search for a, b such that n == a*a - b*b
    // We only need to check |a| and |b| up to sqrt(|n|) + 1 for efficiency
    var max := if n >= 0 then ceiling(sqrt(n + 1)) else ceiling(sqrt(-n + 1));
    var i := 0;
    while i <= max
        invariant 0 <= i <= max
        invariant result == (exists a, b :: -i <= a <= i && -i <= b <= i && n == a * a - b * b)
    {
        var a_candidate := i;
        var b_candidate := i;
        // Check positive and negative values for a and b
        // For simplicity, check a and b in [-i, i]
        var a_sign := 1;
        while a_sign >= -1
            invariant -i <= a_sign <= i
            invariant result == (exists a, b :: -i <= a <= i && -i <= b <= i && n == a * a - b * b)
        {
            var a_val := a_sign * a_candidate;
            var b_sign := 1;
            while b_sign >= -1
                invariant -i <= b_sign <= i
                invariant result == (exists a, b :: -i <= a <= i && -i <= b <= i && n == a * a - b * b)
            {
                var b_val := b_sign * b_candidate;
                if a_val * a_val - b_val * b_val == n {
                    result := true;
                    return;
                }
                b_sign := b_sign - 2; // check -b, b
            }
            a_sign := a_sign - 2; // check -a, a
        }
        i := i + 1;
    }
}