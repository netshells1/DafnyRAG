method AllSequencesSameLength(sequences: seq<seq<int>>) returns (result: bool)
    requires sequences != null
    ensures result ==> (sequences.Length == 0 || forall i :: 0 <= i < sequences.Length ==> |sequences[0]| == |sequences[i]|)
    ensures !result ==> (exists i :: 0 <= i < sequences.Length && |sequences[i]| != |sequences[0]|)
{
    if sequences.Length == 0 {
        return true;
    }

    var firstLength := |sequences[0]|;
    result := true;

    for i := 1 to sequences.Length
        invariant 1 <= i <= sequences.Length
        invariant result ==> forall k :: 0 <= k < i ==> |sequences[k]| == firstLength
    {
        if |sequences[i]| != firstLength {
            result := false;
            break;
        }
    }
}