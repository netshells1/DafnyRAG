Method Signature:
method SumLengthsOfNames(names: seq<string>) returns (totalLength: nat)

Postconditions_prompt:
- totalLength is the sum of the lengths of names in the input list that do not start with a lowercase letter
- Only names that do not start with a lowercase letter are included in the sum