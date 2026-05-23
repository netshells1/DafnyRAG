method RemoveWordsOfLengthK(s: string, k: int) returns (result: string)
    requires k >= 0
    ensures forall w :: w in result.Split(' ') ==> |w| != k
    ensures result == String.Join(" ", (s.Split(' ')).Filter(w => |w| != k))
{
    var words := s.Split(' ');
    var filteredWords := [];
    var i := 0;
    while i < |words|
        invariant 0 <= i <= |words|
        invariant filteredWords == words[..i].Filter(w => |w| != k)
    {
        if |words[i]| != k {
            filteredWords := filteredWords + [words[i]];
        }
        i := i + 1;
    }
    result := String.Join(" ", filteredWords);
}