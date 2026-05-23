method CountMatchingPositions(list1: seq<int>, list2: seq<int>, list3: seq<int>) returns (count: int)
{
    count := 0;
    var minLength := if |list1| < |list2| then |list1| else |list2|;
    minLength := if minLength < |list3| then minLength else |list3|;
    for i := 0 to minLength - 1
        invariant 0 <= i <= minLength
        invariant count == |{ j: int | 0 <= j < i && list1[j] == list2[j] && list2[j] == list3[j] }|
    {
        if list1[i] == list2[i] && list2[i] == list3[i] {
            count := count + 1;
        }
    }
}