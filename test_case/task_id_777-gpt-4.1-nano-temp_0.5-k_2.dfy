predicate IsRepeated(lst: seq<int>, x: int)
{
    |seq.Filter(e => e == x, lst)| > 1
}

function SumOfNonRepeatedElements(lst: seq<int>) : int
{
    Sum(seq Filter(e => !IsRepeated(lst, e), lst))
}

method SumOfUniqueElements(lst: seq<int>) returns (sum: int)
    requires lst != null
    ensures sum == SumOfNonRepeatedElements(lst)
{
    var total := 0;
    var seen := set<int>{};
    var repeated := set<int>{};

    // First pass: identify repeated elements
    for e in lst
        invariant e in lst
        invariant seen <= set e
        invariant repeated <= set e
    {
        if e in seen {
            repeated := repeated + e;
        } else {
            seen := seen + e;
        }
    }

    // Second pass: sum elements not in repeated
    sum := 0;
    for e in lst
        invariant e in lst
        invariant sum >= 0
        invariant sum == Sum(seq Filter(e' => e' != e && e' !in repeated, lst[0..>]))
    {
        if e !in repeated {
            sum := sum + e;
        }
    }
}