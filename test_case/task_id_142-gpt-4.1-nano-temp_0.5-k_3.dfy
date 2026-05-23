method CountMatchingPositions(list1: seq<int>, list2: seq<int>, list3: seq<int>) returns (count: int)
    requires list1 != null
    requires list2 != null
    requires list3 != null
{
    var minLength := if |list1| < |list2| then if |list1| < |list3| then |list1| else |list3| else if |list2| < |list3| then |list2| else |list3|;
    count := 0;
    var i := 0;
    while i < minLength
        invariant 0 <= i <= minLength
        invariant count == |{ j: int | 0 <= j < i && list1[j] == list2[j] && list2[j] == list3[j] }|
    {
        if list1[i] == list2[i] && list2[i] == list3[i] {
            count := count + 1;
        }
        i := i + 1;
    }
}