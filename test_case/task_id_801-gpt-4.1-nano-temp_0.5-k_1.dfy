method CountEqualNumbers(a: int, b: int, c: int) returns (count: int)
    ensures 0 <= count <= 3
    ensures count == (if a == b then 1 else 0) + (if a == c then 1 else 0) + (if b == c then 1 else 0)
{
    count := (if a == b then 1 else 0) + (if a == c then 1 else 0) + (if b == c then 1 else 0);
}