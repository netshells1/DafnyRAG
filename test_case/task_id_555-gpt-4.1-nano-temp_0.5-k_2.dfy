method DifferenceSumCubesAndSum(n: int) returns (diff: int)
  requires n >= 0
  ensures diff == ((n * (n + 1)) / 2) * ((n * (n + 1)) / 2) * ((n * (n + 1)) / 2) - n * (n + 1) / 2
{
    var sumOfNumbers := 0;
    var sumOfCubes := 0;
    var i := 1;
    for i := 1 to n
        invariant 1 <= i <= n + 1
        invariant sumOfNumbers == i * (i - 1) / 2
        invariant sumOfCubes == (i * (i - 1) / 2) * (i * (i - 1) / 2) * (i * (i - 1) / 2)
    {
        sumOfNumbers := sumOfNumbers + i;
        sumOfCubes := sumOfCubes + i * i * i;
    }
    diff := sumOfCubes - sumOfNumbers;
}