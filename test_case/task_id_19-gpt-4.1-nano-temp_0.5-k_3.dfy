method ContainsDuplicate(a: array<int>) returns (result: bool)
    requires a != null
    ensures result <==> (exists i, j :: 0 <= i < j < a.Length && a[i] == a[j])
{
    result := false;
    var seen: set<int> := {};

    for i := 0 to a.Length - 1
        invariant 0 <= i <= a.Length
        invariant seen <= set a[..i]
        invariant result ==> exists k :: 0 <= k < i && a[k] in seen
        invariant !result ==> forall k :: 0 <= k < i ==> a[k] !in seen
    {
        if a[i] in seen {
            result := true;
            break;
        } else {
            seen := seen + {a[i]};
        }
    }
}