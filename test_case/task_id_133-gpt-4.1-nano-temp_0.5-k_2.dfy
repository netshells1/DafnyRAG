method SumOfNegatives(nums: seq<int>) returns (sum: int)
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
    ensures result == sum of all negative elements in s
{
    if |s| == 0 then 0
    else if s[0] < 0 then s[0] + SumNegatives(s[1..])
    else SumNegatives(s[1..])
}