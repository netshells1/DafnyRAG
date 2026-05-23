method CharToAscii(c: char) returns (ascii: int)
    ensures ascii == c as int
{
    ascii := c as int;
}