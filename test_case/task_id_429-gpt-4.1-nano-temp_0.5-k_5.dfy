method ExtractElementAndSequence(s: seq<int>) returns (element: int, subseq: seq<int>)
    requires |s| >= 1
    ensures element == s[0]
    ensures subseq == s[1..]
{
    element := s[0];
    subseq := s[1..];
}