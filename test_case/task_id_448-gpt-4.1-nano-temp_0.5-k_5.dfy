function Perrin(n: int): int
    requires n >= 0
{
    if n == 0 then 3
    else if n == 1 then 0
    else if n == 2 then 2
    else Perrin(n - 2) + Perrin(n - 3)
}

function SumPerrinNumbers(n: int): int
    requires n >= 0
{
    if n == 0 then 0
    else Perrin(n - 1) + SumPerrinNumbers(n - 1)
}