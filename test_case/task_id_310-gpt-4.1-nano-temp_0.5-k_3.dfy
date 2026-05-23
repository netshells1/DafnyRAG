method StringToCharArray(s: string) returns (arr: array<char>)
    ensures arr.Length == |s|
    ensures forall i :: 0 <= i < arr.Length ==> arr[i] == s[i]
{
    arr := new char[|s|];
    var i := 0;
    while i < |s|
        invariant 0 <= i <= |s|
        invariant arr.Length == |s|
        invariant forall k :: 0 <= k < i ==> arr[k] == s[k]
    {
        arr[i] := s[i];
        i := i + 1;
    }
}