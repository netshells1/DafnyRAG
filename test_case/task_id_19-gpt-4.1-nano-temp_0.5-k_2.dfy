method ContainsDuplicates(a: array<int>) returns (result: bool)
    requires a != null
    ensures result <==> (exists i, j :: 0 <= i < j < a.Length && a[i] == a[j])
{
    result := false;
    var seen := new HashSet<int>();
    for i := 0 to a.Length - 1
        invariant 0 <= i <= a.Length
        invariant result <==> (exists k :: 0 <= k < i && a[k] in seen)
        decreases a.Length - i
    {
        if a[i] in seen {
            result := true;
            break;
        } else {
            seen := seen + {a[i]};
        }
    }
}