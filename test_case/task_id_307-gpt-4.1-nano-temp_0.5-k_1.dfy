method DeepCopySequence(s: seq<int>) returns (copy: seq<int>)
    ensures copy == s
    ensures copy != s
{
    // Since sequences are immutable in Dafny, simply returning s suffices for an "identity" copy.
    // To explicitly create a new sequence, we can convert to a sequence via concatenation.
    copy := s + [];
}