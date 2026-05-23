method RemoveWordsOfLengthK(s: string, k: int) returns (result: string)
    requires k >= 0
    ensures forall w :: w in Split(s) && Length(w) == k ==> w not in Split(result)
    ensures forall w :: w in Split(result) ==> (Length(w) != k)
{
    var words := Split(s);
    var filteredWords := [];
    var i := 0;
    while i < |words|
        invariant 0 <= i <= |words|
        invariant filteredWords == [w | j := 0..i-1 :: w in Split(s)[j] && Length(w) != k]
    {
        if Length(words[i]) != k {
            filteredWords := filteredWords + [words[i]];
        }
        i := i + 1;
    }
    result := StringJoin(filteredWords);
}

// Auxiliary functions

function method Split(str: string): seq<string>
{
    // Splits the string into words separated by spaces
    // Implementation detail: For simplicity, assume this function exists
    // or provide a mock implementation
    // Here, we can assume the function is provided by the environment
    // or implement a simple version if needed.
}

function method StringJoin(words: seq<string>): string
{
    // Joins the sequence of words into a single string separated by spaces
    // Implementation detail: Assume this function exists
}