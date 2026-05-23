method RemoveWordsOfLengthK(s: string, k: int) returns (result: string)
    requires k >= 0
    ensures forall w :: w in Words(result) ==> w.Length != k
    ensures forall w :: w in Words(s) && w.Length != k ==> w in Words(result)
    ensures Words(result) is subsequence of Words(s) with all words of length k removed
{
    var words := Words(s);
    var filteredWords := [];
    var i := 0;
    while i < |words|
        invariant 0 <= i <= |words|
        invariant filteredWords == [w | j := 0..i-1 :: w in words[j]]
        {
            if words[i].Length != k {
                filteredWords := filteredWords + [words[i]];
            }
            i := i + 1;
        }
    result := String.Join(" ", filteredWords);
}

// Auxiliary function to split string into words
function Words(s: string): seq<string>
{
    // Simple split by space; assuming words are separated by spaces
    // For simplicity, we consider consecutive non-space characters as words
    var res := [];
    var current := "";
    for c in s
        invariant res == [w | w in res]
    {
        if c != ' ' {
            current := current + c;
        } else if current != "" {
            res := res + [current];
            current := "";
        }
    }
    if current != "" {
        res := res + [current];
    }
    res
}

// Auxiliary function to check if a sequence is a subsequence of another
function method IsSubsequence(sub: seq<string>, full: seq<string>): bool
{
    if |sub| == 0 then true
    else if |full| == 0 then false
    else if sub[0] == full[0] then IsSubsequence(sub[1..], full[1..])
    else IsSubsequence(sub, full[1..])
}