# Quine McCluskey Minimizer

## How to use

Click on the link in the `Releases` Tab to the right of this webpage and download the zip file.

Extract the zip file and double click on the `Quine-McCluskey-Minimizer.exe` file to open the program.

The program has only been deployed on Windows. If you're using a MacOS or Linux, you might need to use Wine to open the exe file. Cross platform deployment coming soon.

## Overview
This program is designed to accept a boolean expression and return a simplified expression, minimized via the Quine-McCluskey algorithm and other ancillary algorithms.

Dependencies are used (read [Acknowledgements](#acknowledgements)), but are unrelated to the implementation of the algorithm. 

The implementation of the Quine-McCluskey algorithm in this program, including the accompanying tests, have been written entirely by myself. To read more about the implementation details regarding the algorithm, see [Implementation Brief](#implementation-brief).

## Features

![image](https://user-images.githubusercontent.com/15359033/210086706-d69d3ccc-c72e-4f5b-8159-f8a5e52c1cce.png)


Takes in either an algebraic expression, a sum of minterms expression or a product of maxterms expression and produces all of the Disjunctive Normal Form as a Sum-of-Products, a Conjunctive Normal Form as a Product-of-Sums, and the truth tables for the minterms and maxterms and optionally draws the Karnaugh Maps if required.

The truth tables can be rearranged on the fly.

![dragging_table_minterms](https://user-images.githubusercontent.com/15359033/210086714-b78a436e-eb8c-4c2d-8f67-db0eb20fad84.gif)

Optionally, either the DNF or CNF can be omitted from the computation, eliminating unnecessary compute time and expediting the computation. (You cannot disable the DNF compute in the minterms tab or the CNF compute in the maxterms tab, the status of checkboxes will not have any effect.)

![image](https://user-images.githubusercontent.com/15359033/210091282-19b2d0c3-b753-411b-9bb3-c4e19795f92f.png)

For extremely complicated expressions (above 9 variables), an approximation may be used to minimise the prime implicants, but only if an exact iterative algorithm is unable to find the answer in a set number of iterations. This still produces the exact essential prime implicants most of the time, but on occasion may produce prime implicants that can be further reduced by combination. This is usually no more than three groups which can be combined into fewer essential prime implicants.

Additionally, extremely complex expressions (above 10 variables) may fail to solve under this algorithm. A timeout (defaulted to 15 seconds) can be specified to stop the computation if it takes too long. Increase the timeout seconds to allow the computation to run longer.

## Acknowledgements
Dependency packages used are `flutter`, `equatable 2.0.0`, `sprintf 7.0.0` and `window_size`.

## Implementation Brief

[Quine McCluskey](https://en.wikipedia.org/wiki/Quine%E2%80%93McCluskey_algorithm) is a method that takes in a set of minterms and produces the essential prime implicants that covers all the minterms. When combined with disjunctions, this produces the simplest disjunctive normal form (DNF), also known as the sum of products (SOP) expression.

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

#### Single Layer Conjunction Root:
```
  *
 / \
A   B 
```
- The entire tree is a product term.

#### Single Layer Disjunctive Root:
```
  +
 / \
A   B 
```
- Each subtree is a product term literal.

#### Double Layer Disjunctive Root:
```
          +
    ______|______
   |      |      |
   *      *      *
  / \    / \    / \
 A   B  C   D  E   F
 ```
 - Each subtree is a product term, which is further comprised of literals.
 
To my knowledge, no other tree forms are possible after disjunctive distribution has been applied to the initial trees, and the maximum height of the tree is 2.

However, this DNF may possess redundancies that cannot be eliminated by distributing over disjunctions. The prime implicants must still be recovered to determine maximum coverage over all minterms with the minimum number of product terms.

After the intermediate DNF is found, we perform a recursive permutation over the literals in each product term to retrieve a set of minterms. For example, the product term `A · C`, under the combination `ABCD`, produces `1010`, `1011`, `1110` and `1111`. This is repeated for every product term until all the minterms are found.

Quine-McCluskey is then applied on this set of minterms, iteratively regrouping them again until all prime implicants are recovered.

Finding essential prime implicants over a set of prime implicants is a set cover problem. We may use linear programming by applying the [Simplex Method](https://en.wikipedia.org/wiki/Simplex_algorithm) over a set of linear constraints, such that it represents our problem domain. The specific method is **0-1 Integer Linear Programming via Simplex Big-M method**.

The specifics of the Simplex Algorithm will be omitted from this brief, but I will illustrate how we may set up the objective function and constraint equations to begin solving for the solution.

We express the prime implicants as notational variables and the minterms that they cover as constraint equations.

For example, for a set of 6 prime implicants recovered, we may express this problem domain in the table form:

| Minterms \ PI |  x₁ | x₂ | x₃ | x₄ | x₅ | x₆ |  Constraint Function |
|---------------|-----|----|----|----|----|--- |----------------------|
|      2        |  1  |  1 |    |    |    |    |   x₁ + x₂ ≥ 1        |
|      3        |  1  |    |    |    | 1  |    |   x₁ + x₅ ≥ 1        |
|      4        |     |    |  1 |    |    |    |   x₃ ≥ 1             |
|      5        |     |    |  1 |    |    |  1 |   x₃ + x₆ ≥ 1        |
|      7        |     |    |    |    | 1  |  1 |   x₅ + x₆ ≥ 1        |
|      8        |     |    |    | 1  |    |    |   x₄ ≥ 1             |
|     10        |     |  1 |    | 1  |    |    |   x₂ + x₄ ≥ 1        |
|     13        |     |    |    |    |    |  1 |   x₆ ≥ 1             |
|     15        |     |    |    |    |    |  1 |   x₆ ≥ 1             |

A `1` represents that the `xᵢ` prime implicant covers the minterm number on the right, so `x₁` covers minterms `2` and `3`, `x₂` covered `2` and `10`, etc, up to `x₆` covering `5, 7, 13, 15`.

The first row represents our _objective function_ `x₁ + x₂ + x₃ + x₄ + x₅ + x₆= Z`, such that `xᵢ ∈ {0, 1}` for `1 ≤ i ≤ 6`, and `Z` must be _minimized_.

Every subsequent row then represents our constraint function, of all which must be greater than or equal to zero, as at least 1 prime implicant must cover the minterm.

Then, we append a constraint for each `xᵢ`, such that `xᵢ ≤ 1` for `1 ≤ i ≤ 6`, so that `xᵢ` falls in the domain `{0, 1}`.

Slack and artificial variables are appended to each constraint function on top of the existing variables based on the nature of expression's inequality. This produces a matrix of constraint functions (rows) against all variables (columns). 

|  Relation | Slack Variable               | Artificial Variable          |
|-----------|------------------------------|------------------------------|
|     ≥     | assigned with coefficient -1 | assigned with coefficient 1  |
|     ≤     | assigned with coefficient  1 | not assigned                 |
|     =     | not assigned                 | assigned with coefficient 1  |

For all the artificial variables that we add, we also need to add them into the objective function. They are given coefficient `M`, a very large constant, in the new objective function. 

In this implementation, `M` is set to `1000`, which is sufficiently large for usage. 

Likewise, all slack variables are given coefficient `0` in the new objective function.

In the example illustrated above, the existence of `8` _greater-than-or-equals-to_ inequalities (notice the last expression is the same as the second-to-last expression) and `6` _less-than-or-equals-to_ inequalities (for each variable bounded below and including 1), produces `8 + 6 = 14` slack variables and `8` artificial variables.

The **new** objective function is hence 
```
1x₁ + 1x₂ + 1x₃ + 1x₄ + 1x₅ + 1x₆ + 0s₁ + 0s₂ + ... + 0s₁₃ + 0s₁₄ + Ma₁ + Ma₂ + ... + Ma₇ + Ma₈ = Z
```

This example is detailed in the first test case in `linear_programming_test.dart`.

Repeated row reduction is performed on the matrix after identifying the pivot column and row, until all the terms of the optimality function (`Zⱼ - Cⱼ`, where `j` is the column index of the matrix) is _non-positive_.

When the optimality condition is reached, such that `Zⱼ - Cⱼ` has no positive elements, the optimal solution is found and can be retrieved from the _variable selection matrix_ that kept track of entering and leaving variables upon each pivot.

Using integer linear programming via Simplex Method, the set cover problem can effectively produce the least set of essential prime implicants that covers the entire range of minterms in polynomial time.

The essential prime implicants are then reconstructed and joined by disjunction, representing the final simplified DNF expression of the given Boolean Algebra expression.

--------------------------------

**Note that Quine-McCluskey is not the best algorithm for minimising an expression of boolean variables.** 

This program becomes intensely slow beyond a 10 variable input. A timeout is implemented to kill the runaway worker thread if a computation takes too long. For an incredibly more efficient algorithm, check out Espresso and the Logic Friday program.
