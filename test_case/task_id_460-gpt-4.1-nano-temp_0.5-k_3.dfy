method FirstElementsOfSublists(sublists: seq<seq<int>>) returns (firsts: seq<int>)
    ensures |firsts| == |sublists|
    && forall i :: 0 <= i < |sublists| ==> 
        (|sublists[i]| > 0 ==> firsts[i] == sublists[i][0]) 
        && (|sublists[i]| == 0 ==> firsts[i] == 0)
{
    firsts := [];
    var i := 0;
    while i < |sublists|
        invariant 0 <= i <= |sublists|
        invariant |firsts| == i
        invariant forall j :: 0 <= j < i ==> 
            (|sublists[j]| > 0 ==> firsts[j] == sublists[j][0]) && (|sublists[j]| == 0 ==> firsts[j] == 0)
    {
        if |sublists[i]| > 0 {
            firsts := firsts + [sublists[i][0]];
        } else {
            firsts := firsts + [0];
        }
        i := i + 1;
    }
}