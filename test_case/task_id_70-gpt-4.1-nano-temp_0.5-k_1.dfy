method AllSequencesSameLength(sequences: seq<seq<int>>) returns (result: bool)
    requires sequences != null
    ensures result ==> (|sequences| == 0 || forall i :: 0 <= i < |sequences| - 1 ==> |sequences[i]| == |sequences[0]|)
    ensures !result ==> exists i :: 0 <= i < |sequences| && |sequences[i]| != (if |sequences| > 0 then |sequences[0]| else 0)
{
    if |sequences| == 0 {
        return true;
    }

    var firstLength := |sequences[0]|;
    result := true;

    for i := 1 to |sequences|
        invariant 1 <= i <= |sequences|
        invariant result ==> forall k :: 0 <= k < i ==> |sequences[k]| == firstLength
    {
        if |sequences[i]| != firstLength {
            result := false;
            break;
        }
    }
}