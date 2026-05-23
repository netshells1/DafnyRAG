predicate IsValidDecimalFormat(s: string)
{
    // Check that s matches pattern: optional sign, digits, '.', exactly two digits
    var parts := s.Split('.');
    parts.Length == 2 &&
    | parts[0] | >= 1 && // at least one digit before decimal
    | parts[1] | == 2 && // exactly two digits after decimal
    // Optional: check that parts[0] is digits
    (forall c :: c in parts[0] ==> '0' <= c <= '9') &&
    (forall c :: c in parts[1] ==> '0' <= c <= '9')
}

method IsDecimalWithPrecision(s: string) returns (result: bool)
    ensures result <==> IsValidDecimalFormat(s)
{
    result := IsValidDecimalFormat(s);
}