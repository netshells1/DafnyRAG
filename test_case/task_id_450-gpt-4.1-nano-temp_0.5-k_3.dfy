method ExtractFirstNStrings(seq: seq<string>, n: int) returns (result: seq<string>)
    requires n >= 0
    requires n <= |seq|
    ensures |result| == n
    ensures result == seq[0..n]
{
    result := seq[0..n];
}