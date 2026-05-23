// Helper function to reverse a string
function ReverseString(s: string): string
    decreases s
{
    if |s| == 0 then ""
    else ReverseString(s[1..]) + s[0..1]
}

method ReverseStringsInList(strings: seq<string>) returns (reversedList: seq<string>)
    ensures |reversedList| == |strings|
    ensures forall i :: 0 <= i < |strings| ==> reversedList[i] == ReverseString(strings[i])
{
    var result := [];
    var i := 0;
    while i < |strings|
        invariant 0 <= i <= |strings|
        invariant |result| == i
        invariant forall j :: 0 <= j < i ==> result[j] == ReverseString(strings[j])
    {
        result := result + [ReverseString(strings[i])];
        i := i + 1;
    }
    return result;
}