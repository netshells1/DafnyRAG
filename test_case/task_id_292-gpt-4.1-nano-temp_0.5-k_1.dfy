method IntegerDivision(dividend: int, divisor: int) returns (quotient: int)
    requires divisor != 0
    ensures quotient == dividend / divisor
{
    quotient := dividend / divisor;
}