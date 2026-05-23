method FindMinSublist(main: seq<int>, sub: seq<int>) returns (startIndex: int, length: int)
    requires main != null
    requires sub != null
    requires |main| >= |sub|
    ensures (exists i :: 0 <= i <= |main| - |sub| && main[i..i + |sub|] == sub) ==> startIndex >= 0 && startIndex <= |main| - |sub| && main[startIndex..startIndex + |sub|] == sub
    ensures (forall i :: 0 <= i < |main| - |sub| + 1 && main[i..i + |sub|] == sub) ==> startIndex == i
    ensures (main[..] !contains sub) ==> startIndex == -1 && length == 0
    ensures (startIndex >= 0) ==> length == |sub|
    ensures (startIndex >= 0) ==> main[startIndex..startIndex + length] == sub
{
    startIndex := -1;
    length := 0;
    var i := 0;
    while i <= |main| - |sub| 
        invariant 0 <= i <= |main| - |sub|
        invariant startIndex == -1 || (startIndex >= 0 && main[startIndex..startIndex + length] == sub)
        decreases |main| - i
    {
        if main[i..i + |sub|] == sub {
            startIndex := i;
            length := |sub|;
            // Since we want the minimal length sublist, we can break after first occurrence
            break;
        }
        i := i + 1;
    }
}