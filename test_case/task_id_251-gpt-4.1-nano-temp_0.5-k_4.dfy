method InsertBeforeEach(lst: seq<string>, s: string) returns (result: seq<string>)
    ensures |result| == 2 * |lst|
    ensures forall i :: 0 <= i < |result| ==>
        if i % 2 == 0 then
            result[i] == s
        else
            result[i] == lst[i / 2]
{
    result := [];
    var n := |lst|;
    var i := 0;
    while i < n
        invariant 0 <= i <= n
        invariant |result| == 2 * i
        invariant forall k :: 0 <= k < i ==> result[2 * k] == s && result[2 * k + 1] == lst[k]
    {
        result := result + [s, lst[i]];
        i := i + 1;
    }
}