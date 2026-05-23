method AllSequencesSameLength(sequences: seq<seq<int>>) returns (result: bool)
    requires sequences != null
    ensures result ==> (sequences.Length == 0 || forall i, j :: 0 <= i < sequences.Length && 0 <= j < sequences.Length ==> sequences[i].Length == sequences[j].Length)
    ensures !result ==> (exists i, j :: 0 <= i < sequences.Length && 0 <= j < sequences.Length && sequences[i].Length != sequences[j].Length)
{
    if sequences.Length == 0 {
        return true;
    }

    var firstLength := sequences[0].Length;
    result := true;

    for i := 1 to sequences.Length
        invariant 1 <= i <= sequences.Length
        invariant result ==> forall k :: 0 <= k < i ==> sequences[k].Length == firstLength
    {
        if sequences[i].Length != firstLength {
            result := false;
            break;
        }
    }
}