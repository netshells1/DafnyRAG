method ExtractStrings(seq: seq<string>, size: nat) returns (result: seq<string>)
    requires size <= |seq|
    ensures |result| == size
    ensures result == seq[..size]
{
    // Simply return the prefix of length 'size' from the sequence
    result := seq[..size];
}