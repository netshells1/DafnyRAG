Method Signature:
Postconditions_prompt:

Postconditions_prompt:
- The length of the returning sequence equals the length of the input sequence
- For each index i in 0 .. |strs| - 1:
    - If strs[i] is not empty, then chars[i] is the last character of strs[i]
    - If strs[i] is empty, then chars[i] is some default or placeholder value (e.g., '\0')