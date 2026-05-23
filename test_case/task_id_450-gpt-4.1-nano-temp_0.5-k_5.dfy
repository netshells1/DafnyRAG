method ExtractStrings(seq: seq<string>, size: int) returns (result: seq<string>)
    requires 0 <= size <= |seq|
    ensures |result| == size
    ensures result == seq[..size]
{
    result := seq[..size];
}