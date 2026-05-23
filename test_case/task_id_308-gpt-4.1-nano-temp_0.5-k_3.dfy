method TopKProducts(a: array<int>, b: array<int>, k: nat) returns (result: seq<int>)
  requires a != null && b != null
  requires a.Length > 0 && b.Length > 0
  requires 0 < k <= a.Length * b.Length
  ensures |result| == k
  ensures forall i :: 0 <= i < |result| ==> exists ai, bi :: ai in a && bi in b && result[i] == ai * bi
  ensures forall i, j :: 0 <= i < j < |result| ==> result[i] >= result[j]
{
    var products := new seq<int>(0);
    // Collect all products
    var allProducts := new seq<int>();
    for ai in a
      for bi in b
        allProducts := allProducts + [ai * bi];

    // Sort all products in descending order
    var sortedProducts := allProducts;
    // Bubble sort for simplicity; in practice, use a more efficient sort
    var n := sortedProducts.Length;
    var swapped: bool;
    do
      invariant 0 <= i <= n
      decreases n - i
    {
      swapped := false;
      var i := 0;
      while i + 1 < n
        invariant 0 <= i <= n
        invariant sortedProducts[..i] == old(sortedProducts[..i]) // No change before i
        decreases n - i
      {
        if sortedProducts[i] < sortedProducts[i + 1]
        {
          var temp := sortedProducts[i];
          sortedProducts := sortedProducts[..i] + [sortedProducts[i + 1]] + sortedProducts[i + 2..];
          sortedProducts := sortedProducts[..i + 1] + [temp] + sortedProducts[i + 2..];
          swapped := true;
        }
        i := i + 1;
      }
    }
    while swapped;

    // Take the first k elements
    result := sortedProducts[..k];
}