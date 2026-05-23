Method Signature:
method RotateLeftBits(n: uint, d: int) returns (r: uint)

Postconditions_prompt:
- The returned value r is a 32-bit unsigned integer
- r equals the input number n rotated left by d bits
- The rotation is performed modulo 32, so rotating by d is equivalent to rotating by d mod 32
- The bits shifted out from the left are reintroduced on the right side of the number