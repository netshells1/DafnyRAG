method RotatedElement(arr: array<int>, k: int, n: int) returns (result: int)
    requires arr.Length > 0
    requires 0 <= k < arr.Length
    requires n >= 0
    ensures result == arr[(k - n + arr.Length) % arr.Length]
{
    var index := (k - n + arr.Length) % arr.Length;
    result := arr[index];
}