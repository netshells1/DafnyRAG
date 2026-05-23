predicate IsLowerCase(c : char)
{
    97 <= c as int <= 122
}

predicate IsUpperCase(c : char)
{
    65 <= c as int <= 90
}

predicate IsLowerUpperPair(c : char, C : char)
{
    (c as int) + 32 == (C as int)
}

predicate IsUpperLowerPair(C : char, c : char)
{
    (C as int) - 32 == (c as int)
}

method ToggleCase(s: string) returns (v: string)
    ensures |v| == |s|
    ensures forall i :: 0 <= i < |s| ==> 
            if IsLowerCase(s[i]) then IsLowerUpperPair(s[i], v[i]) 
            else if IsUpperCase(s[i]) then IsUpperLowerPair(s[i], v[i]) 
            else v[i] == s[i]
{
    var s' : string := [];
    for i := 0 to |s|
        invariant 0 <= i <= |s|
        invariant |s'| == i
        invariant forall k :: 0 <= k < i ==> 
            if IsLowerCase(s[k]) then IsLowerUpperPair(s[k], s'[k]) 
            else if IsUpperCase(s[k]) then IsUpperLowerPair(s[k], s'[k]) 
            else s'[k] == s[k]
    {
        if IsLowerCase(s[i]) {
            s' := s' + [ShiftMinus32(s[i])];
        } else if IsUpperCase(s[i]) {
            s' := s' + [ShiftPlus32(s[i])];
        } else {
            s' := s' + [s[i]];
        }
    }
    return s';
}

function ShiftMinus32(c : char) : char
{
    ((c as int - 32) % 128) as char
}

function ShiftPlus32(c : char) : char
{
    ((c as int + 32) % 128) as char
}