method IsDecimalWithTwoPrecision(s: string) returns (result: bool)
    ensures result <==> 
      (exists prefix: string, fractionalPart: string ::
          s == prefix + "." + fractionalPart && 
          |fractionalPart| == 2 && 
          forall c :: c in fractionalPart ==> '0' <= c as int <= '9')
{
    // Initialize result to false
    result := false;

    // Check if string contains exactly one decimal point
    var dotCount := 0;
    var dotIndex := -1;
    var i := 0;
    while i < |s|
        invariant 0 <= i <= |s|
        invariant dotCount >= 0
    {
        if s[i] == '.'
        {
            dotCount := dotCount + 1;
            dotIndex := i;
        }
        i := i + 1;
    }

    if dotCount == 1 && dotIndex != 0 && dotIndex != |s| - 1
    {
        var prefix := s[..dotIndex];
        var fractionalPart := s[dotIndex + 1 ..];

        if |fractionalPart| == 2 && 
           (forall c :: c in fractionalPart ==> '0' <= c as int <= '9')
        {
            result := true;
        }
    }
}