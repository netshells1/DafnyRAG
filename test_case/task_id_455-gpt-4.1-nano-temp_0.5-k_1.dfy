method Has31Days(month: int) returns (result: bool)
  requires 1 <= month <= 12
  ensures result <==> (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12)
{
    result := (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12);
}