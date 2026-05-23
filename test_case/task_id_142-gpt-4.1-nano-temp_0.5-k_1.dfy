method CountMatchingPositions(list1: seq<int>, list2: seq<int>, list3: seq<int>) returns (count: int)
    ensures count >= 0
    ensures count == | set i: int | 0 <= i < |list1| && 0 <= i < |list2| && 0 <= i < |list3| && list1[i] == list2[i] && list2[i] == list3[i] |
{
    var minLength := if |list1| < |list2| then if |list1| < |list3| then |list1| else |list3| else if |list2| < |list3| then |list2| else |list3|;
    count := 0;
    var i := 0;
    while i < minLength
        invariant 0 <= i <= minLength
        invariant count >= 0
        invariant count == | set j: int | 0 <= j < i && list1[j] == list2[j] && list2[j] == list3[j] |
    {
        if list1[i] == list2[i] && list2[i] == list3[i] {
            count := count + 1;
        }
        i := i + 1;
    }
}