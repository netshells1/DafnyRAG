method CountMatchingPositions(list1: seq<int>, list2: seq<int>, list3: seq<int>) returns (count: int)
    ensures count >= 0
    ensures count == |{ i :: 0 <= i < |list1| && list1[i] == list2[i] && list2[i] == list3[i] }|
{
    var len := if |list1| < |list2| then |list2| else |list1|;
    len := if len < |list3| then len else |list3|;

    count := 0;
    var i := 0;
    while i < len
        invariant 0 <= i <= len
        invariant count == |{ j :: 0 <= j < i && list1[j] == list2[j] && list2[j] == list3[j] }|
    {
        if list1[i] == list2[i] && list2[i] == list3[i] {
            count := count + 1;
        }
        i := i + 1;
    }
}