method HasNoProfitNoLoss(amount: int, cost: int) returns (result: bool)
    ensures result <==> amount == cost
{
    result := amount == cost;
}