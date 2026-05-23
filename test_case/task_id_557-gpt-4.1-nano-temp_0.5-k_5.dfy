predicate IsUpperCase(c: char)
{
    65 <= c as int <= 90
}

predicate IsLowerCase(c: char)
{
    97 <= c as int <= 122
}

predicate IsLetter(c: char)
{
    IsUpperCase(c) || IsLowerCase(c)
}

predicate IsUpperLowerPair(c: char, C: char)
{
    (c as int) + 32 == C as int
}

predicate IsLowerUpperPair(c: char, C: char)
{
    (c as int) == C as int + 32
}

method ToggleCase(s: string) returns (v: string)
    ensures |v| == |s|
    ensures forall i :: 0 <= i < |s| ==> 
            (IsUpperCase(s[i]) ==> IsLowerCase(v[i]))
            && (IsLowerCase(s[i]) ==> IsUpperCase(v[i]))
            && (!IsLetter(s[i]) ==> v[i] == s[i])
{
    var s' : string := [];
    for i := 0 to |s|
        invariant 0 <= i <= |s|
        invariant |s'| == i
        invariant forall k :: 0 <= k < i ==> 
                        (IsUpperCase(s[k]) ==> IsLowerCase(s'[k]))
                        && (IsLowerCase(s[k]) ==> IsUpperCase(s'[k]))
                        && (!IsLetter(s[k]) ==> s'[k] == s[k])
    {
        if IsUpperCase(s[i]) {
            s' := s' + [ShiftMinus32(s[i])]; // convert uppercase to lowercase
        } else if IsLowerCase(s[i]) {
            s' := s' + [ShiftPlus32(s[i])]; // convert lowercase to uppercase
        } else {
            s' := s' + [s[i]];
        }
    }
    return s';
}

predicate IsUpperCase(c: char)
{
    65 <= c as int <= 90
}

predicate IsLowerCase(c: char)
{
    97 <= c as int <= 122
}

predicate IsLetter(c: char)
{
    IsUpperCase(c) || IsLowerCase(c)
}

predicate IsUpperLowerPair(c: char, C: char)
{
    (c as int) + 32 == C as int
}

predicate IsLowerUpperPair(c: char, C: char)
{
    (c as int) == C as int + 32
}

function ShiftMinus32(c: char): char
{
    ((c as int) - 32) as char
}

function ShiftPlus32(c: char): char
{
    ((c as int) + 32) as char
}