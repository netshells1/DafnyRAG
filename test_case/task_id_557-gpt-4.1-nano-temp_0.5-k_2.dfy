predicate IsUpperCase(c : char)
{
    65 <= c as int <= 90
}

predicate IsLowerCase(c : char)
{
    97 <= c as int <= 122
}

predicate IsUpperLowerPair(C : char, c : char)
{
    (C as int) == (c as int) - 32
}

predicate IsLowerUpperPair(c : char, C : char)
{
    (c as int) == (C as int) + 32
}

method ToggleCase(s: string) returns (v: string)
    ensures |v| == |s|
    ensures forall i :: 0 <= i < |s| ==> 
        (if IsUpperCase(s[i]) then IsLowerCase(v[i]) && IsUpperLowerPair(s[i], v[i]) 
         else if IsLowerCase(s[i]) then IsUpperCase(v[i]) && IsLowerUpperPair(v[i], s[i]) 
         else v[i] == s[i])
{
    var s' : string := [];
    for i := 0 to |s|
        invariant 0 <= i <= |s|
        invariant |s'| == i
        invariant forall k :: 0 <= k < i ==> 
            (if IsUpperCase(s[k]) then IsLowerCase(s'[k]) && IsUpperLowerPair(s[k], s'[k]) 
             else if IsLowerCase(s[k]) then IsUpperCase(s'[k]) && IsLowerUpperPair(s'[k], s[k]) 
             else s'[k] == s[k])
    {
        if IsUpperCase(s[i])
        {
            s' := s' + [ShiftMinus32(s[i])];
        }
        else if IsLowerCase(s[i])
        {
            s' := s' + [ShiftPlus32(s[i])];
        }
        else
        {
            s' := s' + [s[i]];
        }
    }
    return s';
}

function ShiftMinus32(c : char) :  char
{
    ((c as int - 32) % 128) as char
}

function ShiftPlus32(c : char) :  char
{
    ((c as int + 32) % 128) as char
}