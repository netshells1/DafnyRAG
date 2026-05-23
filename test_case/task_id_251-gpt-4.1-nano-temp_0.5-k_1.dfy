method InsertBeforeEach(lst: seq<string>, s: string) returns (result: seq<string>)
    ensures |result| == 2 * |lst|
    ensures forall i :: 0 <= i < |lst| ==> result[2 * i] == s
    ensures forall i :: 0 <= i < |lst| ==> result[2 * i + 1] == lst[i]
{
    var res := [];
    var i := 0;
    while i < |lst|
        invariant 0 <= i <= |lst|
        invariant |res| == 2 * i
        {
            res := res + [s, lst[i]];
            i := i + 1;
        }
    result := res;
}