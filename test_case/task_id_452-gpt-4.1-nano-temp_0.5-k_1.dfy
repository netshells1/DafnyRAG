method LossAmount(saleAmount: int, costPrice: int) returns (loss: int)
    ensures (saleAmount < costPrice) ==> loss == costPrice - saleAmount
    ensures (saleAmount >= costPrice) ==> loss == 0
{
    if saleAmount < costPrice {
        loss := costPrice - saleAmount;
    } else {
        loss := 0;
    }
}