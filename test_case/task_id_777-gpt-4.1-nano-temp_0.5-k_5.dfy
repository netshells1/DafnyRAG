method SumOfUniqueElements(lst: seq<int>) returns (sum: int)
    requires lst != null
    ensures sum == SumOfElementsAppearingOnce(lst)
{
    var freq := map<int,int>{};
    // Count the frequency of each element
    foreach x in lst
        invariant forall k :: k in freq ==> freq[k] >= 0
    {
        if x in freq {
            freq[x] := freq[x] + 1;
        } else {
            freq[x] := 1;
        }
    }
    sum := SumOfSelectedElements(lst, freq);
}

// Ghost function to compute sum of elements with frequency 1
ghost function SumOfSelectedElements(lst: seq<int>, freq: map<int,int>) : int
{
    if |lst| == 0 then 0
    else
        let x := lst[0] in
        let rest := lst[1..] in
        if x in freq && freq[x] == 1 then
            x + SumOfSelectedElements(rest, freq)
        else
            SumOfSelectedElements(rest, freq)
}

// Helper function to verify the sum matches the expected sum
function SumOfElementsAppearingOnce(lst: seq<int>) : int
{
    var freq := map<int,int>{};
    // Count frequencies
    var _ := 
        (forall x :: x in lst ==> 
            (if x in freq then freq[x] := freq[x] + 1 else freq[x] := 1));
    // Sum elements with frequency 1
    SumOfSelectedElements(lst, freq)
}