method SumOfNegativeNumbers(nums: seq<int>) returns (sum: int)
    ensures sum == SumNegatives(nums)
{
    sum := 0;
    var i := 0;
    while i < |nums|
        invariant 0 <= i <= |nums|
        invariant sum == SumNegatives(nums[..i])
    {
        if nums[i] < 0 {
            sum := sum + nums[i];
        }
        i := i + 1;
    }
}

function SumNegatives(s: seq<int>): int
    decreases s
{
    if |s| == 0 then 0
    else
        let head := s[0];
        let tail := s[1..];
        if head < 0 then head + SumNegatives(tail)
        else SumNegatives(tail)
    }
}