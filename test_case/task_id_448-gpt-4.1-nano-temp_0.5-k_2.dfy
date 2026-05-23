method SumPerrin(n: int) returns (sum: int)
  requires n >= 0
  ensures sum == SumPerrin(n)
{
    sum := 0;
    var i := 0;
    var p0 := 3;
    var p1 := 0;
    var p2 := 2;
    var count := 0;
    while count < n
        invariant 0 <= count <= n
        invariant sum == SumPerrin(count)
        invariant p0 == PerrinNumber(count)
        invariant p1 == PerrinNumber(count - 1)
        invariant p2 == PerrinNumber(count - 2)
        invariant i == count
    {
        sum := sum + p0;
        var nextPerrin := p2 + p1;
        p2 := p1;
        p1 := p0;
        p0 := nextPerrin;
        i := i + 1;
        count := count + 1;
    }
}

function SumPerrin(n: int): int
  requires n >= 0
{
    if n == 0 then 0
    else
        var sum := 0;
        var p0 := 3;
        var p1 := 0;
        var p2 := 2;
        var i := 0;
        var count := 0;
        while count < n
            invariant 0 <= count <= n
            invariant sum == SumPerrin(count)
            invariant p0 == PerrinNumber(count)
            invariant p1 == PerrinNumber(count - 1)
            invariant p2 == PerrinNumber(count - 2)
            invariant i == count
        {
            sum := sum + p0;
            var nextPerrin := p2 + p1;
            p2 := p1;
            p1 := p0;
            p0 := nextPerrin;
            i := i + 1;
            count := count + 1;
        }
        sum
}

function PerrinNumber(k: int): int
  requires k >= 0
{
    if k == 0 then 3
    else if k == 1 then 0
    else if k == 2 then 2
    else PerrinNumber(k - 2) + PerrinNumber(k - 3) + PerrinNumber(k - 1)
}