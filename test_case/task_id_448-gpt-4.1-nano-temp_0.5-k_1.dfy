method SumPerrin(n: int) returns (sum: int)
    requires n >= 0
    ensures sum == SumPerrinNumbers(n)
{
    sum := 0;
    var i := 0;
    var p := 3; // Perrin(0) = 3
    var q := 0; // Perrin(1) = 0
    var r := 2; // Perrin(2) = 2
    var index := 0;
    // Initialize Perrin sequence for n+1 terms
    var PerrinSeq := new int[n+1];
    if n >= 0 then {
        PerrinSeq[0] := 3;
    }
    if n >= 1 then {
        PerrinSeq[1] := 0;
    }
    if n >= 2 then {
        PerrinSeq[2] := 2;
    }
    // Compute Perrin numbers up to n
    var j := 3;
    while j <= n
        invariant 0 <= j <= n+1
        invariant PerrinSeq[0..j-1] == PerrinNumbersUpTo(j-1)
        decreases n - j + 1
    {
        var next := PerrinSeq[j-3] + PerrinSeq[j-2];
        PerrinSeq[j] := next;
        j := j + 1;
    }
    // Sum the Perrin numbers up to n
    var k := 0;
    while k <= n
        invariant 0 <= k <= n+1
        invariant sum == sum of Perrin numbers from 0 to k-1
        decreases n - k + 1
    {
        sum := sum + PerrinSeq[k];
        k := k + 1;
    }
}

function SumPerrinNumbers(n: int): int
    requires n >= 0
{
    if n == 0 then 3
    else if n == 1 then 3 + 0
    else if n == 2 then 3 + 0 + 2
    else
        var seq := new int[n+1];
        seq[0] := 3;
        seq[1] := 0;
        seq[2] := 2;
        var i := 3;
        while i <= n
            invariant 3 <= i <= n+1
            invariant forall j :: 0 <= j < i ==> seq[j] == Perrin(j)
            decreases n - i
        {
            seq[i] := seq[i-3] + seq[i-2];
            i := i + 1;
        }
        var total := 0;
        var j := 0;
        while j <= n
            invariant 0 <= j <= n+1
            invariant total == sum of Perrin numbers from 0 to j-1
            decreases n - j
        {
            total := total + seq[j];
            j := j + 1;
        }
        total
}

predicate Perrin(j: int)
{
    // Perrin sequence definition
    (j == 0) ==> 3
    |j == 1 ==> 0
    |j == 2 ==> 2
    |j >= 3 ==> Perrin(j-3) + Perrin(j-2)
}