# Quine McCluskey

[Quine McCluskey](https://en.wikipedia.org/wiki/Quine%E2%80%93McCluskey_algorithm) is a method that takes in a set of minterms and produces the essential prime implicants that covers all the minterms. When combined with disjunctions, this produces the simplest disjunctive normal form (DNF), also known as the sum of products expression.

The implementation in this program will take in _any_ boolean expression and automatically group it into a naive disjunctive normal form. This is done through expressing each group of terms with the same operator in Polish notation, such that they form a tree.
```
             + 
       _____ |_______  
      /      |       \
     *       *        *
    / \     / \     / | \
   A   B   +  ~C   A  C ~D
          / \
         B   D
```    
If two exactly same operator nodes form a parent-child relationship (i.e. conjunction-conjunction or disjunction-disjunction), they can be flattened and all terms compresses into one branch. This reduces the number of steps required for later term distribution, where entire branches need to be reconstructed. 

```
     +                        +
    / \                   ____|____
   *   +      ------>    *    |   |
  / \ / \               / \   C   D
 A  B C  D             A   B
``` 
 
Preliminary simplification is done through identifying disjunction subtrees, beginning from the leaf nodes in recursive fashion, and distributing terms upwards into their parent trees, until no more distribution is possible and a disjunctive normal form is obtained.

```
     +                         +                           +  
    / \                       / \                        / | \
   *   E   --Distribute-->   +   D   -- Flatten -->     *  *  D
  / \                       / \                       / |  | \
 A   +                     *   *                     A  B  A  C
    / \                  / |   | \
   B   C                A  B   A  C
```

There are only three possible disjunctive normal form trees:

Single Layer Conjunction Root:
```
  *
 / \
A   B 
```
- The entire tree is a product term.

Single Layer Disjunctive Root:
```
  +
 / \
A   B 
```
- Each subtree is a product term literal.

Double Layer Disjunctive Root:
```
          +
    ______|______
   |      |      |
   *      *      *
  / \    / \    / \
 A   B  C   D  E   F
 ```
 - Each subtree is a product term, which is further comprised of literals.
 
To my knowledge, no other tree forms are possible after disjunctive distribution has been applied to the initial trees.

However, this DNF may possess redundancies that cannot be eliminated by distributing over disjunctions. The prime implicants must still be recovered to determine maximum coverage over all minterms with the minimum number of product terms.

After the intermediate DNF is found, we perform a recursive permutation over the literals in each product term to retrieve a set of minterms. For example, the product term `A · C`, under the combination `ABCD`, produces `1010`, `1011`, `1110` and `1111`. This is repeated for every product term until all the minterms are found.

Quine-McCluskey is then applied on this set of minterms, iteratively regrouping them again until all prime implicants are recovered.

Finding essential prime implicants over a set of prime implicants reduces to a set cover problem, which reduces to a vertex cover problem. We may use linear programming by applying the Simplex Method over a set of linear constraints, such that it represents our problem domain. The specific method is **0-1 Integer Linear Programming via Simplex Big-M method**.

We express the prime implicants as notational variables and the minterms that they cover as constraint equations.

For example, for a set of 6 prime implicants recovered, we may express this problem domain in the table form:

| Minterms \ PI |  x1 | x2 | x3 | x4 | x5 | x6 |
|---------------|-----|----|----|----|----|--- |
|      2        |  1  |  1 |    |    |    |    |
|      3        |  1  |    |    |    | 1  |    |
|      4        |     |    |  1 |    |    |    |
|      5        |     |    |  1 |    |    |  1 |
|      7        |     |    |    |    | 1  |  1 |
|      8        |     |    |    | 1  |    |    |
|     10        |     |  1 |    | 1  |    |    |
|     13        |     |    |    |    |    |  1 |
|     15        |     |    |    |    |    |  1 |

A `1` represents that the `x_i` prime implicant covers the minterm number on the right, so `x1` covers minterms `2` and `3`, `x2` covered `2` and `10`, etc, up to `x6` covering `5, 7, 13, 15`.

The first row represents our objective function `x1 + x2 + ... + x6 = Z`, such that `x_i ∈ {0, 1}` for `1 ≤ i ≤ 6`, which we must _minimize_.
Every subsequent row then represents our constraint function, of all which must be greater than or equal to zero, as at least 1 prime implicant must cover the minterm.
So, the first constraint is `x1 + x2 ≥ 1`, the second constraint is `x1 + x5 ≥ 1`, etc.
We then append a constraint for each `x_i`, such that `x_i ≤ 1`, so that x_i falls in the domain {0, 1}.

The intricacies of the Simplex Method and the representation of constraint functions in the implementation will be omitted in this brief. In simple terms, the Simplex Method with Big M appends slack and aritificial variables to each constraint function on top of exisiting variables based on the nature of expression's inequality and produces a matrix of constraint functions (rows) against all variables (columns). Repeated row reduction is performed on the matrix until all the terms of the optimality function (objective variables subtracted by column dot product (Z_j - C_j, where j is the column index)) is non-positive.

Using integer linear programming via Simplex Method, the set cover problem can effectively produce the least set of essential prime implicants that covers the entire range of minterms in polynomial time.

The essential prime implicants are then reconstructed and joined by disjunction, representing the final simplified DNF expression of the given Boolean Algebra expression.

