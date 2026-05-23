method SumOfPerrinNumbers(n: int) returns (sum: int)
  requires n >= 0
  ensures sum == SumPerrinNumbers(n)
{
    sum := 0;
    var i := 0;
    var a := new int[n+1];
    // Initialize Perrin sequence array
    if n >= 0 {
        a[0] := 3;
        if n >= 1 {
            a[1] := 0;
        }
        if n >= 2 {
            a[2] := 2;
        }
        var j := 3;
        while j <= n
            invariant 3 <= j <= n+1
            invariant forall k :: 0 <= k < j ==> a[k] == Perrin(k)
            invariant a[0] == 3 && a[1] == 0 && a[2] == 2
        {
            a[j] := a[j - 2] + a[j - 3];
            j := j + 1;
        }
        sum := 0;
        var k := 0;
        while k < n
            invariant 0 <= k <= n
            invariant sum == sum of Perrin numbers from 0 to k-1
            invariant sum == SumPerrinNumbers(k)
        {
            sum := sum + a[k];
            k := k + 1;
        }
    }
}

// Helper function to define Perrin number
function Perrin(k: int): int
  requires k >= 0
{
    if k == 0 then 3
    else if k == 1 then 0
    else if k == 2 then 2
    else Perrin(k - 2) + Perrin(k - 3)
}

// Function to sum first n Perrin numbers
function SumPerrinNumbers(n: int): int
  requires n >= 0
{
    if n == 0 then 0
    else Perrin(n - 1) + SumPerrinNumbers(n - 1)
}