method SumOfNegativeNumbers(nums: seq<int>) returns (sum: int)
    ensures sum == SumNegatives(nums)
{
    sum := 0;
    var i := 0;
    while i < |nums|
        invariant 0 <= i <= |nums|
        invariant sum == SumNegatives(nums[0..i])
    {
        if nums[i] < 0 {
            sum := sum + nums[i];
        }
        i := i + 1;
    }
}

// Auxiliary function to sum negative numbers in a sequence
function SumNegatives(seq: seq<int>): int
    decreases seq
{
    if |seq| == 0 then 0
    else
        var head := seq[0];
        var tail := seq[1..];
        if head < 0 then head + SumNegatives(tail)
        else SumNegatives(tail)
}