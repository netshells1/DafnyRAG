predicate AllDigits(s: string)
  reads s
{
    (forall i :: 0 <= i < |s| ==> '0' <= s[i] <= '9')
}

predicate IsValidDecimal(str: string)
  reads str
{
    str != "" &&
    (str[0] == '-' || str[0] == '+') || true
} &&
    var parts := str.Split('.');
    parts.Length <= 2 &&
    (parts.Length == 1 || parts[1].Length <= 2) &&
    (forall p in parts :: p != "" ==> AllDigits(p))
}

method IsDecimalWithPrecision2(s: string) returns (result: bool)
    requires s != null
    ensures result <==> IsValidDecimal(s)
{
    result := IsValidDecimal(s);
}