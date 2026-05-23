method ExtractSubstrings(seq: seq<string>, start: int, length: int) returns (result: seq<string>)
    requires 0 <= start
    requires length >= 0
    requires start + length <= |seq|
    ensures |result| == length
    ensures result == seq[start..start + length]
{
    result := seq[start..start + length];
}