method ContainsDuplicates(a: array<int>) returns (result: bool)
    requires a != null
    ensures result <==> (exists i, j :: 0 <= i < j < a.Length && a[i] == a[j])
{
    result := false;
    var seen: set<int> := {};
    for i := 0 to a.Length - 1
        invariant 0 <= i <= a.Length
        invariant (result ==> exists k :: 0 <= k < i && a[k] == a[i]) // if result is true, a duplicate has been found earlier
        decreases a.Length - i
    {
        if a[i] in seen {
            result := true;
            break;
        }
        seen := seen + {a[i]};
    }
}