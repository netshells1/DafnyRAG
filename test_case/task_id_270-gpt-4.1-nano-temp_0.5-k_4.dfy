// Helper function to compute sum of even numbers at even positions
function sumOfEvenNumbersAtEvenPositions(arr: array<int>): int
  requires arr != null
  decreases arr.Length
{
  if arr.Length == 0 then 0
  else
    let tailSum := sumOfEvenNumbersAtEvenPositions(arr[1..])
    if 0 % 2 == 0 && IsEven(arr[0]) then arr[0] + tailSum
    else tailSum
}

// Predicate to check if a number is even
predicate IsEven(n: int)
{
  n % 2 == 0
}

method SumEvenAtEvenPositions(a: array<int>) returns (sum: int)
  requires a != null
  ensures sum == sumOfEvenNumbersAtEvenPositions(a)
{
  sum := 0;
  var i := 0;
  while i < a.Length
    invariant 0 <= i <= a.Length
    invariant sum == sumOfEvenNumbersAtEvenPositions(a[..i])
    // The slice a[..i] contains elements from 0 to i-1
  {
    if i % 2 == 0 && IsEven(a[i]) {
      sum := sum + a[i];
    }
    i := i + 1;
  }
}