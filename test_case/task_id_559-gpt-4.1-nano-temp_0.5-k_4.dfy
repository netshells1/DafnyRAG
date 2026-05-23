function MaxSubarraySum(a: array<int>) : int
  requires a != null
  decreases a.Length
{
  if a.Length == 0 then 0
  else
    var maxEndingHere := a[0];
    var maxSoFar := a[0];
    var i := 1;
    while i < a.Length
      invariant 1 <= i <= a.Length
      invariant maxEndingHere == MaxSuffixSum(a[..i])
      invariant maxSoFar == MaxSubarraySumPrefix(a[..i])
      decreases a.Length - i
    {
      var current := a[i];
      maxEndingHere := if maxEndingHere + current > current then maxEndingHere + current else current;
      if maxEndingHere > maxSoFar {
        maxSoFar := maxEndingHere;
      }
      i := i + 1;
    }
    maxSoFar
}

method MaxSumSubarray(a: array<int>) returns (maxSum: int)
  requires a != null
  ensures maxSum == if a.Length > 0 then MaxSubarraySum(a) else 0
{
    maxSum := MaxSubarraySum(a);
}

// Auxiliary functions to specify the properties used in invariants
function MaxSuffixSum(s: seq<int>) : int
  requires |s| >= 0
{
  if |s| == 0 then 0
  else
    var maxEndingHere := s[0];
    var maxSuffix := s[0];
    var i := 1;
    while i < |s|
      invariant 1 <= i <= |s|
      invariant maxEndingHere == MaxSuffixSum(s[..i])
      invariant maxSuffix == MaxSuffixSum(s[..i])
      decreases |s| - i
    {
      var current := s[i];
      maxEndingHere := if maxEndingHere + current > current then maxEndingHere + current else current;
      if maxEndingHere > maxSuffix {
        maxSuffix := maxEndingHere;
      }
      i := i + 1;
    }
    maxSuffix
}

function MaxSubarraySumPrefix(s: seq<int>) : int
  requires |s| >= 0
{
  if |s| == 0 then 0
  else
    var maxSum := s[0];
    var currentSum := s[0];
    var i := 1;
    while i < |s|
      invariant 1 <= i <= |s|
      invariant currentSum == MaxSubarraySumPrefix(s[..i])
      invariant maxSum >= currentSum
      decreases |s| - i
    {
      var current := s[i];
      currentSum := if currentSum + current > current then currentSum + current else current;
      if currentSum > maxSum {
        maxSum := currentSum;
      }
      i := i + 1;
    }
    maxSum
}