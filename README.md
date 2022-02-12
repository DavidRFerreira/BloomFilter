# Bloom Filter

Implementation of a Bloom Filter in the Swift language for space-efficent storage of sets.

Implemented operations:
- Add element to Bloom Filter.
- Check if Bloom Filter contains an element.
- Check if Bloom Filter is empty. 
- Compute the probability of false positivity.
- Compute the optimal number of hashes to apply to an element. 

## Table of Contents 
1. [Brief Explanation of Bloom Filters](#installation)
    1. [Advantages](#advantages) 
    2. [Disadvantages](#disadvantages)
    3. [Applications](#applications)
    4. [Implementation Overview](#implementation-overview)
        1. [Insertion and Verification](#insertion-and-verification)
        2. [Optimal Number of Hash Functions](#optimal-number-of-hash-functions)
        3. [Probability of False Positives](#probability-of-false-positives)
2. [Implementation Notes](#implementation-notes)
3. [Usage Example](#usage-example)
4. [References](#further-readings)


<a name="explanation"/>

## Brief Explanation of Bloom Filters

A Bloom Filter is a space-efficient probabilistic data structure that checks whether or not an element is present in a set. 

It is space-efficient because it doesn't store the actual element but its hash. 

It is probabilistic, because it is only able to tell if an element **is probably** in the set without certainty. This leads to the probability of false positives. But, a Bloom Filter can always tell if an element **is definitely not** in the set. 

<a name="Advantages"/>

### Advantages

Bloom Filters is a data structure that provides many advatanges over simple HashTables, including:

- Space efficiency: Bloom Filter does not store the actual items, it's just an array of integers. 
- Performance: Insertion and search both take O(1) time. 

<a name="Disadvantages"/>

### Disadvantages

For some applications, Bloom Filters can provide disadvantes as:

- Ocorrence of false posives may be not bearable for some applications.
- Pure implemention of a Bloom Filter doesn't support the delete operation.
- The size of the filter is defined a priori base on the number of expected elements to store (and the desired false positive probability). This makes it impossible to store extra elements without increasing the false positive probability. 

<a name="Applications"/>

### Applications

A Bloom Filter can be used in many different situations. Some of these applications are:
- Check whether a user has already read a post before or not. 
- Detect a second request for a web object to cache it avoiding to cache objects which are requested by users just once. 
- Identify malicious URLs.
- Identifify weak passwords. 

<a name="Implementation"/>

### Implementation Overview

<a name="Insertion"/>

#### Insertion and Verification

A Bloom filter is essentialy an array that stores 0s and 1s. After we create a Bloom Filter and before inserting any element, all m positions are set to 0. 

| 0 | 0 | 0 | 0 | 0 | ... | 0 |

When we want to add an element to the Bloom Filter, we hash that element with k hash functions. After we get k integer hash values, we set the filter's positions with index equal to those k hash values to 1 % m (size of the filter).

For example, we want to **insert** the word "bloom" on a Bloom Filter of size 10. We can pass it through 3 hash functions:
h1("bloom") = 101
h2("bloom") = 47
h3("bloom") = 13

We then check the index of the positions to set to 1: 
101 % 10 = 1
47 % 10 = 7
13 % 10 = 3

So, we add the "bloom" word by setting to 1 the positions 1, 3 and 7.

| 1 | 0 | 1 | 0 | 0 | 0 | 1 | 0 | 0 | 0 |

Now, if we want to check if the Bloom Filter contains the "bloom" word, we hash it like we did to add it in the first place and check if those positions are set to one. 

So, "Bloom" has the hash output [1, 3, 7] and all those filter's positions are set to 1. We can say that "Bloom" **may be present** on the Bloom Filter. We can not tell that for sure because after adding many elements, there is a slight probability that those positions were set to 1 by adding those elements. 

But, if one of the indexes - in this example, [1, 3, 7] - is not set to 1, we can tell with certantity that "bloom" is not present on the Bloom Filter since after setting a position to 1 we never set them back to 0 again.

<a name="Optimal"/>

#### Optimal Number of Hash Functions

We can compute the optimal number of hash functions that should be applied to an element before adding it to the Bloom Filter (and therefore also when we check its existence).

```
k = (m / n) * (ln(2))
```
where
- m is the size of the bit array,
- n is the number of expected elements to be inserted on the filter.

<a name="Probability"/>

#### Probability of False Positives

We can compute the probability of false positives ocurring, with

```
P = pow(1 - exp(-k / (m / n)), k)
```
where
- m is the size of the bit array,
- k is the number of hash functions,
- n is the number of expected elements to be inserted on the filter. 

<a name="Implementation"/>

## Implementation Notes

This implementation uses the [**Hasher**](https://developer.apple.com/documentation/swift/hasher) structur available in Swift since version 4.2. This reduces multiple hashes to a single hash in an efficient way. This Hasher uses a seed in order to ensure that the results will not collide. This is an alternative to hash an element with multiple different hash functions or to hash it with the same function but adding random numbers.

This implementation provides the next methods: 

| **Method** | **Description** |
| --- | --- |
| init(filterSize: Int, numExpectedElements: Int) | Bloom Filter class's constructor. Expects the size of the bit array and the number of expected elements to be inserted |
| hash(value: String) | Hashes an element by mapping its sequence of bytes to an integer hash value.  |
| falsePositiveProbability() | Computes the probability of ocurring false positives when checking if an element exists in the Bloom Filter.  |
| optimalHashesNumber(filterSize: Int, numExpectedElements: Int) | Computes the optimal number of hash functions to apply to the values being inserted.  |
| add(value: String) | Adds an element to the Bloom Filter. |
| contains(value: String) | Verifies if the Bloom Filter contains an element. |
| isEmpty() | Verifies if the Bloom Filter is empty. |

<a name="Usage"/>

## Usage Example

```swift
var bloomFilter = BloomFilter(filterSize: 35, numExpectedElements: 30)
print(bloomFilter.falsePositiveProbability())
print(bloomFilter.isEmpty())
bloomFilter.add(value: "bloom")
bloomFilter.add(value: "filter")
print(bloomFilter.contains(value: "bloom"))
print(bloomFilter.contains(value: "bloom1"))
print(bloomFilter.isEmpty())
```

**Output:**
```
0.5756271543230502
true
true
false
false
```
<a name="Further"/>

## Further Readings
Medjedovic, D., & Tahirovic, E. (2021). Algorithms and Data Structures for Massive Datasets. Manning Publications.
Almeida, P., Baquero, C., Preguiça, N., & Hutchison, D. (2007). Scalable Bloom Filters. Information Processing Letters, Volume 101, Issue 6.