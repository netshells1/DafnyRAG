method LucasNumber(n: int) returns (result: int)
  requires n >= 0
  ensures result == 
            if n == 0 then 2
            else if n == 1 then 1
            else exists k :: 2 <= k <= n && 
                var prevPrev := 2;
                var prev := 1;
                var curr := 0;
                // Loop to compute Lucas(k)
                for i := 2 to n
                  invariant 2 <= i <= n + 1
                  invariant prevPrev == Lucas(i - 2)
                  invariant prev == Lucas(i - 1)
                  invariant curr == Lucas(i)
                {
                  curr := prev + prevPrev;
                  prevPrev := prev;
                  prev := curr;
                }
                // After loop, curr == Lucas(n)
                result == curr
{
    var prevPrev := 2;
    var prev := 1;
    var curr := 0;
    if n == 0 {
        result := 2;
        return;
    } else if n == 1 {
        result := 1;
        return;
    }
    for i := 2 to n
        invariant 2 <= i <= n
        invariant prevPrev == 2 + (i - 2) // Lucas(i - 2)
        invariant prev == 1 + (i - 2) // Lucas(i - 1)
        invariant curr == 0
    {
        curr := prev + prevPrev;
        prevPrev := prev;
        prev := curr;
    }
    result := curr;
}