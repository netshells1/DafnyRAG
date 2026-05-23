Method Signature:
method CalculateLoss(amount: int) returns (loss: int)

Postconditions_prompt:
- If the amount represents a loss, the returned loss should be equal to the absolute difference between the cost price and sale price
    - If there is no loss, the returned loss should be 0