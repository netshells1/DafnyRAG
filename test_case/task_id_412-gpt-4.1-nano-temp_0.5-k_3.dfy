predicate IsEven(n: int)
{
    n % 2 == 0
}

method RemoveOdds(a: array<int>) returns (result: array<int>)
    requires a != null
    ensures forall i :: 0 <= i < result.Length ==> IsEven(result[i])
    ensures forall i :: 0 <= i < a.Length && IsEven(a[i]) ==> exists j :: 0 <= j < result.Length && result[j] == a[i]
    ensures forall i :: 0 <= i < result.Length ==> result[i] in a[..]
{
    var evens: seq<int> := [];
    var i: int := 0;
    while i < a.Length
        invariant 0 <= i <= a.Length
        invariant evens.Length <= i
        invariant forall k :: 0 <= k < evens.Length ==> IsEven(evens[k])
        invariant forall k :: 0 <= k < i && IsEven(a[k]) ==> a[k] in evens
    {
        if IsEven(a[i]) {
            evens := evens + [a[i]];
        }
        i := i + 1;
    }
    result := evens.ToArray();
}