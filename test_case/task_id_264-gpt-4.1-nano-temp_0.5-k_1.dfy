method DogAgeInDogYears(age: int) returns (dogYears: int)
    requires age >= 0
    ensures dogYears == age * 7
{
    dogYears := age * 7;
}