predicate IsDigit(c: char)
{
    48 <= c as int <= 57
}

method IsDecimalWithTwoPrecision(s: string) returns (result: bool)
    ensures result <==> (
        exists i :: 0 <= i < |s| && s[i] == '.' ==> 
            (|s| - (i + 1) <= 2 && 
             forall j :: i+1 <= j < |s| ==> s[j] in ['0','1','2','3','4','5','6','7','8','9'])
        )
)
{
    var dotIndex := -1;
    result := true;
    var i := 0;
    while i < |s|
        invariant 0 <= i <= |s|
        invariant dotIndex == -1 || (0 <= dotIndex < |s|)
        invariant result
    {
        if s[i] == '.' {
            if dotIndex != -1 {
                // More than one decimal point
                result := false;
                break;
            }
            dotIndex := i;
        }
        i := i + 1;
    }
    if dotIndex != -1 {
        // Check digits after decimal point
        var digitsAfter := |s| - (dotIndex + 1);
        if digitsAfter > 2 {
            result := false;
        } else {
            var j := dotIndex + 1;
            while j < |s|
                invariant dotIndex != -1 && dotIndex + 1 <= j <= |s|
                invariant result
            {
                if s[j] !in ['0','1','2','3','4','5','6','7','8','9'] {
                    result := false;
                    break;
                }
                j := j + 1;
            }
        }
    }
}