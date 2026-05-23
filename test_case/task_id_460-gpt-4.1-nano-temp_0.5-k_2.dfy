method FirstElementsOfSublists(lists: seq<seq<int>>) returns (result: seq<int>)
{
    var res := new int[|lists|];
    var i := 0;
    while i < |lists|
        invariant 0 <= i <= |lists|
        invariant |res| == i
        invariant forall j :: 0 <= j < i ==> 
            (|lists[j]| > 0 ==> res[j] == lists[j][0]) && (|lists[j]| == 0 ==> res[j] == 0)
    {
        if |lists[i]| > 0 {
            res[i] := lists[i][0];
        } else {
            res[i] := 0;
        }
        i := i + 1;
    }
    result := res;
}