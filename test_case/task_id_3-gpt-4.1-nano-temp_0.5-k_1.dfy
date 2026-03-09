method IsComposite(n: int) returns (result: bool)
  requires n >= 2
  ensures result <==> (exists k :: 2 <= k < n && n % k == 0)
{
    result := false;
    var k := 2;
    while k < n
        invariant 2 <= k <= n
        invariant result <==> (exists j :: 2 <= j < k && n % j == 0)
    {
        if n % k == 0
        {
            result := true;
            break;
        }
        k := k + 1;
    }
}