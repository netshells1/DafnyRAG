method InsertBeforeEach(lst: seq<string>, s: string) returns (result: seq<string>)
    ensures |result| == 2 * |lst|
    ensures forall i :: 0 <= i < |result| ==> 
        (i % 2 == 0 ==> result[i] == s) &&
        (i % 2 == 1 ==> result[i] == lst[i/2])
{
    var res := [];
    var i := 0;
    while i < |lst|
        invariant 0 <= i <= |lst|
        invariant |res| == 2 * i
        {
            // Append s before lst[i]
            res := res + [s, lst[i]];
            i := i + 1;
        }
    result := res;
}