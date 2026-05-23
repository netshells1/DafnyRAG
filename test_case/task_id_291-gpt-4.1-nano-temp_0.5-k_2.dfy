method CountFencePaintings(n: int, k: int) returns (ways: int)
  requires n >= 0
  requires k >= 1
  ensures ways == if n == 0 then 1
                  else if n == 1 then k
                  else (k - 1) * (CountFencePaintings(n - 1, k) + CountFencePaintings(n - 2, k))
{
    var prev2 := 1; // ways for n=0
    var prev1 := k; // ways for n=1
    if n == 0 {
        ways := 1;
        return;
    } else if n == 1 {
        ways := k;
        return;
    }
    var current := 0;
    for i := 2 to n
        invariant 2 <= i <= n + 1
        invariant prev2 == if i - 2 == 0 then 1 else ??? // invariants to be refined
        invariant prev1 == if i - 1 == 0 then 1 else ??? // invariants to be refined
        invariant current == (k - 1) * (prev1 + prev2)
    {
        current := (k - 1) * (prev1 + prev2);
        prev2 := prev1;
        prev1 := current;
    }
    ways := current;
}