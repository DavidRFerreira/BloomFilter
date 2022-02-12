//
//  BloomFilter.swift
//  BloomFilter
//
//  Created by David Ferreira on 11/02/2022.
//

import Foundation

/// Space-efficient probabilistic data structure to test if an element is a member of a set.
/// It is space-efficient since it doesn't store the actual elements.
/// It is probabilistic because it only checks if a value is "possibly in the set" without certainty.
/// But it can check if a value is "definitely not in the set".
/// Search complexity: O(1).
class BloomFilter {
    private var bloomFilter = Array<Bool>()
    private var filterSize = 0
    private var numExpectedElements = 0
    private var numHashFunctions = 0
    private var seeds = [Int]()
    
    /// Class constructor.
    /// - Parameter filterSize: number of bits in filter.
    /// - Parameter numExpectedElements: number of elements expected in the filter.
    init(filterSize: Int, numExpectedElements: Int = 100000) {
        self.filterSize = filterSize
        self.numExpectedElements = numExpectedElements
        
        self.bloomFilter = Array(repeating: false, count: filterSize)
        self.numHashFunctions = optimalHashesNumber(filterSize: filterSize, numExpectedElements: numExpectedElements)
        self.seeds = (0..<self.numHashFunctions).map({_ in Int.random(in: 0..<Int.max)})
    }
    
    /// Hashes an element by mapping its sequence of bytes to an integer hash value.
    /// - Parameter value: string to hash.
    /// - Returns: Integer hash value.
    private func hash(value: String) -> [Int] {
        return seeds.map({ seed -> Int in
                var hasher = Hasher()
                hasher.combine(value)
                hasher.combine(seed)
                let hashValue = abs(hasher.finalize())
                return hashValue
        })
    }
    
    /// Computes probability of ocurring false positives when checking if an element exists in the Bloom Filter.
    /// - Returns: probability of false positives.
    public func falsePositiveProbability() -> Double {
        let x1 : Double = 1 - exp(Double(-numHashFunctions) / (Double(filterSize) / Double(numExpectedElements)))
        let p = pow(Decimal(x1), numHashFunctions)
        return (p as NSDecimalNumber).doubleValue
    }
    
    /// Computes the optimal number of hash functions to apply to the values being inserted,
    /// while ensuring that this number is between [1, 2,147,483,647].
    /// - Returns: optimal number for hash functions.
    public func optimalHashesNumber(filterSize: Int, numExpectedElements: Int) -> Int {
        var optimalHashNumber = Int(Double(filterSize / numExpectedElements) * log(2.0))
        
        optimalHashNumber = max(optimalHashNumber, 1)
        optimalHashNumber = min(optimalHashNumber, Int.max)
        
        return optimalHashNumber
    }
 
    /// Adds an element to the Bloom Filter.
    /// - Parameter value: element to add.
    public func add(value: String) {
        // The element needs to be hashed into an integer before being inserted.

        hash(value: value).forEach({ hash in
            bloomFilter[hash % bloomFilter.count] = true
        })
    }
    
    /// Verifies if the Bloom Filter contains an element.
    /// - Parameter value: element to check.
    /// - Returns: true if it may exist, false if it doesn't exist for certain.
    public func contains(value: String) -> Bool {
        return hash(value: value).allSatisfy({ hash in
            bloomFilter[hash % bloomFilter.count]
        })
    }
    
    /// Verifies if the Bloom Filter is empty.
    /// - Returns: true if empty.
    public func isEmpty() -> Bool {
        return bloomFilter.allSatisfy({$0 == false})
    }
}
