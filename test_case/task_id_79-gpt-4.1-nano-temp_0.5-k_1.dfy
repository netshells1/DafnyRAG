method IsWordLengthOdd(word: string) returns (result: bool)
    ensures result <==> (|word| % 2 == 1)
{
    result := (|word| % 2 == 1);
}