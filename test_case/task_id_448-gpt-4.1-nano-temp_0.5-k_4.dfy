method SumPerrin(n: int) returns (sum: int)
    requires n >= 0
    ensures sum == PerrinSum(n)
{
    var a := new int[n+3]; // Perrin sequence array, with extra for initial values
    // Initialize first three Perrin numbers
    a[0] := 3;
    a[1] := 0;
    a[2] := 2;
    var i := 3;
    // Compute Perrin sequence up to n
    while i <= n
        invariant 3 <= i <= n+1
        invariant a[0..i] == PerrinSequence(i)
        decreases n - i
    {
        a[i] := a[i - 3] + a[i - 2];
        i := i + 1;
    }
    // Sum the first n Perrin numbers
    sum := 0;
    var j := 0;
    while j < n
        invariant 0 <= j <= n
        invariant sum == sumOfArray(a, j)
        decreases n - j
    {
        sum := sum + a[j];
        j := j + 1;
    }
}

function PerrinSequence(i: int): seq<int>
    requires i >= 0
{
    if i == 0 then [3]
    else if i == 1 then [0]
    else if i == 2 then [2]
    else
        var seq1 := PerrinSequence(i - 1);
        var seq2 := PerrinSequence(i - 2);
        var seq3 := PerrinSequence(i - 3);
        seq1 + [seq1[|seq1|-1] + seq2[|seq2|-1]]
}

function sumOfArray(a: array<int>, length: int): int
    requires 0 <= length <= a.Length
{
    if length == 0 then 0 else sumOfArray(a, length - 1) + a[length - 1]
}