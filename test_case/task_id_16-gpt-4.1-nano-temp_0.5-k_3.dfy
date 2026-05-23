predicate IsLowercaseLetter(c: char)
{
    97 <= c as int <= 122
}

method ContainsUnderscoreLowercaseSequence(s: string) returns (result: bool)
    ensures result <==> exists start, end :: 0 <= start < end <= |s| &&
                                   (forall i :: start <= i < end ==> IsLowercaseLetter(s[i])) &&
                                   exists i :: start <= i < end && s[i] == '_' &&
                                   (forall j :: end <= j < |s| ==> IsLowercaseLetter(s[j]))
{
    result := false;
    var i := 0;
    while i <= |s|
        invariant 0 <= i <= |s|
        invariant result <==> (
            exists start, end :: 0 <= start < end <= i &&
                (forall k :: start <= k < end ==> IsLowercaseLetter(s[k])) &&
                exists k :: start <= k < end && s[k] == '_' &&
                (forall j :: end <= j < i ==> IsLowercaseLetter(s[j]))
        )
    {
        if s[i] == '_' {
            // Check for lowercase sequence before underscore
            var start := i - 1;
            while start >= 0 && IsLowercaseLetter(s[start])
                invariant start >= -1
                invariant 0 <= i
                invariant result <==> (
                    exists st, en :: 0 <= st < en <= i &&
                        (forall k :: st <= k < en ==> IsLowercaseLetter(s[k])) &&
                        exists k :: st <= k < en && s[k] == '_' &&
                        (forall j :: en <= j < i ==> IsLowercaseLetter(s[j]))
                )
            {
                start := start - 1;
            }
            start := start + 1; // Adjust to first lowercase letter in sequence
            var endSeq := i + 1;
            // Check for lowercase sequence after underscore
            while endSeq < |s| && IsLowercaseLetter(s[endSeq])
                invariant endSeq >= i + 1
                invariant 0 <= i
                invariant result <==> (
                    exists st, en :: 0 <= st < en <= i &&
                        (forall k :: st <= k < en ==> IsLowercaseLetter(s[k])) &&
                        exists k :: st <= k < en && s[k] == '_' &&
                        (forall j :: en <= j < endSeq && IsLowercaseLetter(s[j]))
                )
            {
                endSeq := endSeq + 1;
            }
            if start >= 0 && endSeq <= |s| && start < endSeq
                && (forall k :: start <= k < endSeq ==> IsLowercaseLetter(s[k]))
                && (exists k :: start <= k < endSeq && s[k] == '_')
                && (forall j :: endSeq <= j < |s| ==> IsLowercaseLetter(s[j]))
            {
                result := true;
                return;
            }
        }
        i := i + 1;
    }
}