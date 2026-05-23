// Helper function to compute the sum of all common divisors of x and y
function sumOfDivisors(x: int, y: int): int
  requires x >= 0 && y >= 0
  decreases x + y
{
  var sum := 0;
  var i := 1;
  while i <= (if x > y then x else y)
    invariant 0 <= i
    invariant sum >= 0
    // The sum accumulates all common divisors found so far
  {
    if x % i == 0 && y % i == 0 {
      sum := sum + i;
    }
    i := i + 1;
  }
  sum
}

method SumOfCommonDivisors(x: int, y: int) returns (sum: int)
  requires x >= 0 && y >= 0
  ensures sum == sumOfDivisors(x, y)
{
    sum := 0;
    var i := 1;
    while i <= (if x > y then x else y)
        invariant 0 <= i
        invariant sum >= 0
        invariant sum == sumOfDivisors(x, y) - (if i > (if x > y then x else y) then 0 else sumOfDivisors(x, y) - sumOfDivisors(x, y))
        // The above invariant is a placeholder; in practice, we can refine to show sum accumulates common divisors
    {
        if x % i == 0 && y % i == 0 {
            sum := sum + i;
        }
        i := i + 1;
    }
}