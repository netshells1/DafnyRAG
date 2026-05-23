method InsertBeforeEach(lst: seq<string>, s: string) returns (res: seq<string>)
    ensures |res| == 2 * |lst|
    ensures forall i :: 0 <= i < |lst| ==> res[2 * i] == s && res[2 * i + 1] == lst[i]
{
    res := [];
    var i := 0;
    while i < |lst|
        invariant 0 <= i <= |lst|
        invariant |res| == 2 * i
        {
            res := res + [s, lst[i]];
            i := i + 1;
        }
}