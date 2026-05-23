method SumOfCommonDivisors(a: int, b: int) returns (result: int)
  requires a >= 0 && b >= 0
  ensures result == SumCommonDivisors(a, b)
{
    var min := if a < b then a else b;
    result := 0;
    var d := 1;
    while d <= min
        invariant 1 <= d <= min + 1
        invariant result == sum of all common divisors up to d - 1
    {
        if a % d == 0 && b % d == 0 {
            result := result + d;
        }
        d := d + 1;
    }
}

// Helper function to specify the sum of common divisors for the postcondition
function SumCommonDivisors(a: int, b: int): int
  requires a >= 0 && b >= 0
  decreases a + b
{
  var min := if a < b then a else b;
  var sum := 0;
  var d := 1;
  while d <= min
    invariant 1 <= d <= min + 1
    invariant sum == sum of all common divisors up to d - 1
  {
    if a % d == 0 && b % d == 0 {
      sum := sum + d;
    }
    d := d + 1;
  }
  sum
}