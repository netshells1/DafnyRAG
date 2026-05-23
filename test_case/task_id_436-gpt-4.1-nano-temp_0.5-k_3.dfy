/**
 * Extracts all negative numbers from an array of integers, preserving order.
 **/

method GetNegativeNumbers(arr: array<int>) returns (negatives: seq<int>)
    ensures forall i :: 0 <= i < |negatives| ==> negatives[i] < 0
    ensures forall i :: 0 <= i < |negatives| ==> negatives[i] in arr[..]
    ensures forall i :: 0 <= i < |negatives| ==> arr[?i] == negatives[i]
{
    negatives := [];
    var i := 0;
    if arr != null {
        while i < arr.Length
            invariant 0 <= i <= arr.Length
            invariant forall k :: 0 <= k < i ==> arr[k] in arr[..] && arr[k] < 0
            invariant forall k :: 0 <= k < |negatives| ==> negatives[k] in arr[..] && negatives[k] < 0
            invariant |negatives| == countNegatives(arr[..i])
        {
            if arr[i] < 0 {
                negatives := negatives + [arr[i]];
            }
            i := i + 1;
        }
    }
}

function countNegatives(seq: seq<int>) : nat
    ensures forall i :: 0 <= i < |seq| ==> seq[i] < 0
{
    if |seq| == 0 then 0
    else if seq[0] < 0 then 1 + countNegatives(seq[1..])
    else countNegatives(seq[1..])
}