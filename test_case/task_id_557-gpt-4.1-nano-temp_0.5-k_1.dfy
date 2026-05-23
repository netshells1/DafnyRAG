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
    (c as int) + 32 == C as int
}

predicate IsUpperLowerPair(C : char, c : char)
{
    C as int + 32 == c as int
}

function ToggleChar(c : char) : char
{
    if IsLowerCase(c) then
        // Convert to uppercase
        ((c as int) - 32) as char
    else if IsUpperCase(c) then
        // Convert to lowercase
        ((c as int) + 32) as char
    else
        c
}

method ToggleCase(s: string) returns (v: string)
    ensures |v| == |s|
    ensures forall i :: 0 <= i < |s| ==> 
                if IsLowerCase(s[i]) then IsUpperCase(v[i]) && IsLowerUpperPair(s[i], v[i]) 
                else if IsUpperCase(s[i]) then IsLowerCase(v[i]) && IsUpperLowerPair(v[i], s[i]) 
                else v[i] == s[i]
{
    var s' : string := [];
    for i := 0 to |s|
        invariant 0 <= i <= |s|
        invariant |s'| == i
        invariant forall k :: 0 <= k < i ==> 
            (IsLowerCase(s[k]) ==> IsUpperCase(s'[k]) && IsLowerUpperPair(s[k], s'[k]))
            && (IsUpperCase(s[k]) ==> IsLowerCase(s'[k]) && IsUpperLowerPair(s'[k], s[k]))
            && (!IsLowerCase(s[k]) && !IsUpperCase(s[k]) ==> s[k] == s'[k])
        {
            var c := s[i];
            var toggled := ToggleChar(c);
            s' := s' + [toggled];
        }
    return s';
}