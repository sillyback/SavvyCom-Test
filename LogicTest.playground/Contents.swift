import UIKit

// MARK: Find the index that has the sum of left’s elements equal to the sum of right’s elements
func findMiddleIndex(of array: [Int]) -> Int? {
    if array.isEmpty {
        print("Empty array")
        return nil
    }
    /// Nested function
    func sum(to: Int) -> Int {
        var sum = 0
        for index in 0..<to {
            sum += array[index]
        }
        return sum
    }
    /// Nested function
    func sum(from: Int) -> Int {
        var sum = 0
        for index in from..<array.count {
            sum += array[index]
        }
        return sum
    }
    /// Save total sum of whole array
    let total: Int = sum(to: array.count)
    /// Middle index
    let middleIndex = array.count / 2
    
    // Verify array's length
    if middleIndex == 0 {
        print("Middle index is 0")
        return 0
    }
    
    if middleIndex == array.count - 1 {
        if array[0] == 0 {
            print("Middle index is \(middleIndex)")
            return middleIndex
        } else if array[middleIndex] == 0 {
            print("Middle index is 0")
            return 0
        }
        print("Index not found")
        return nil
    }
    
    // Loop for front half
    for index in 1..<middleIndex {
        if (total - array[index]) % 2 == 0 {
            if sum(to: index) == sum(from: index + 1) {
                print("Middle index is \(index)")
                return index
            }
        }
    }
    
    // Loop for post half if front half didn't have result
    for index in middleIndex..<array.count {
        if (total - array[index]) % 2 == 0 {
            if sum(to: index) == sum(from: index + 1) {
                print("Middle index is \(index)")
                return index
            }
        }
    }
    
    print("Index not found")
    return nil
}

let array = [1, 2, 3, 4, 5, 6, 7, 8]
findMiddleIndex(of: array)



// MARK: - Function to detect that incoming string is palindrome or not

func isPalindrome(string: String) -> Bool {
    if string.isEmpty {
        print("Empty string")
        return false
    }
    
    var reverseString = ""
    
    let array = Array(string)
    for index in 0..<array.count {
        reverseString.insert(array[index], at: reverseString.startIndex)
    }
    
    if string.lowercased() == reverseString.lowercased() {
        print("\(string) is a palindrome")
        return true
    }
    
    print("\(string) isn't a palindrome")
    return false
}

isPalindrome(string: "Level")
