predicate IsSpace(c: char)
{
    c == ' '
}

method ReplaceSpaces(s: string) returns (v: string)
    ensures |v| == |s|
    ensures forall i :: 0 <= i < |s| ==> (s[i] == ' ' ==> v[i..i+2] == "%20") && (s[i] != ' ' ==> v[i] == s[i])
{
    var v' : string := [];
    var i := 0;
    while i < |s|
        invariant 0 <= i <= |s|
        invariant |v'| == i + (CountSpaces(s, 0, i))
        // CountSpaces counts how many spaces are in s[0..i-1]
        decreases |s| - i
    {
        if IsSpace(s[i])
        {
            v' := v' + "%20";
        }
        else
        {
            v' := v' + [s[i]];
        }
        i := i + 1;
    }
    return v';
}

function CountSpaces(s: string, start: int, end_: int): int
    requires 0 <= start <= end_ <= |s|
{
    var count := 0;
    var j := start;
    while j < end_
        invariant 0 <= j <= end_
        invariant count == |[k | k := start .. j-1; IsSpace(s[k])]||
        decreases end_ - j
    {
        if IsSpace(s[j]) {
            count := count + 1;
        }
        j := j + 1;
    }
    count
}