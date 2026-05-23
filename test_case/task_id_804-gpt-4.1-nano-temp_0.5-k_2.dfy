predicate IsEven(n: int)
{
    n % 2 == 0
}

method IsProductEven(arr: array<int>) returns (result: bool)
    ensures result <==> exists i :: 0 <= i < arr.Length && IsEven(arr[i])
{
    result := false;
    var i := 0;
    while i < arr.Length
        invariant 0 <= i <= arr.Length
        invariant result <==> exists j :: 0 <= j < i && IsEven(arr[j])
    {
        if IsEven(arr[i])
        {
            result := true;
            break;
        }
        i := i + 1;
    }
}