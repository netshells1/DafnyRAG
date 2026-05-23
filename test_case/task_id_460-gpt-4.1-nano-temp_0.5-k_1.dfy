method GetFirstElements(sublists: seq<seq<int>>) returns (firsts: seq<int>)
    requires sublists != null
    ensures firsts.Length == sublists.Length
    ensures forall i :: 0 <= i < sublists.Length ==> 
                (|sublists[i]| > 0 ==> firsts[i] == sublists[i][0]) &&
                (|sublists[i]| == 0 ==> firsts[i] == 0)
{
    firsts := [];
    var n := sublists.Length;
    var result := new int[n];
    var i := 0;
    while i < n
        invariant 0 <= i <= n
        invariant result.Length == n
        invariant forall j :: 0 <= j < i ==> 
            (|sublists[j]| > 0 ==> result[j] == sublists[j][0]) &&
            (|sublists[j]| == 0 ==> result[j] == 0)
    {
        if |sublists[i]| > 0 {
            result[i] := sublists[i][0];
        } else {
            result[i] := 0;
        }
        i := i + 1;
    }
    firsts := result;
}