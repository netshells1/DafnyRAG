predicate IsSpace(c: char)
{
    c == ' '
}

method ReplaceSpaces(s: string) returns (v: string)
    ensures |v| >= |s|
    ensures forall i :: 0 <= i < |s| ==> (IsSpace(s[i]) ==> exists j :: 0 <= j <= |v| - 3 && v[j..j+2] == "%20") && (s[i] != ' ' ==> v[i + offset] == s[i])
{
    var v' := "";
    var i := 0;
    while i < |s|
        invariant 0 <= i <= |s|
        invariant |v'| == sum of 1 or 3 per iteration
        {
        if IsSpace(s[i]) {
            v' := v' + "%20";
        } else {
            v' := v' + [s[i]];
        }
        i := i + 1;
    }
    v := v';
}