method AllElementsEqualToElement(a: array<int>, x: int) returns (result: bool)
    requires a != null
    ensures result ==> forall i :: 0 <= i < a.Length ==> a[i] == x
    ensures !result ==> exists i :: 0 <= i < a.Length && a[i] != x
{
    result := true;
    var i := 0;
    while i < a.Length
        invariant 0 <= i <= a.Length
        invariant result ==> forall k :: 0 <= k < i ==> a[k] == x
        invariant !result ==> exists k :: 0 <= k < i && a[k] != x
    {
        if a[i] != x {
            result := false;
            break;
        }
        i := i + 1;
    }
}