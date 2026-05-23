method RemoveWordsOfLengthK(s: string, k: int) returns (result: string)
  requires 0 < k <= |s|
  ensures forall w :: w in Words(result) ==> length(w) != k
  ensures result == StringFromWords(Words(result))
{
    var words := Words(s);
    var filteredWords := [];
    var i := 0;
    while i < |words|
        invariant 0 <= i <= |words|
        invariant filteredWords == [w | w in words[..i] && length(w) != k]
    {
        if length(words[i]) != k {
            filteredWords := filteredWords + [words[i]];
        }
        i := i + 1;
    }
    result := StringFromWords(filteredWords);
}

// Auxiliary functions (assuming they are defined elsewhere):

// Parses the string into a sequence of words separated by spaces
function method Words(s: string): seq<string> 
{
    // Implementation details are assumed
}

// Reconstructs a string from a sequence of words separated by spaces
function method StringFromWords(words: seq<string>): string
{
    // Implementation details are assumed
}