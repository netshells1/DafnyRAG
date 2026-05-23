method ReplaceLastWithSecond(l1: seq<int>, l2: seq<int>) returns (result: seq<int>)
    requires |l1| > 0
    ensures |result| == |l1| - 1 + |l2|
    ensures forall i :: 0 <= i < |l1| - 1 ==> result[i] == l1[i]
    ensures result[|l1| - 1 ..] == l2
{
    // Take all elements except the last from l1
    var prefix := l1[..|l1|-1];
    // Concatenate with l2
    result := prefix + l2;
}