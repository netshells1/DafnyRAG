Method Signature:
method IsMonth30Days(month: int) returns (result: bool)

Postconditions_prompt:
- The result is true if the month number corresponds to a month with 30 days (April, June, September, November)
- The result is false if the month number corresponds to a month with 31 days or February (month 2)