import UIKit

// MARK: Find the index that has the sum of left’s elements equal to the sum of right’s elements
func findMiddleIndex(of array: [Int]) -> Int? {
    guard array.count >= 3 else {
        print("Index not found")
        return nil
    }
    
    var total: Int = 0
    var left: Int = array[0]
    
    for i in 0..<array.count {
        total += array[i]
    }
    
    for i in 1..<array.count - 1 {
        if left == total - left - array[i] {
            print("Middle index is \(i)")
            return i
        }
        left += array[i]
    }

    print("Index not found")
    return nil
}

let array = [-1, -2, -3, 0, 0, 6, 2, -8]
findMiddleIndex(of: array)



// MARK: - Function to detect that incoming string is palindrome or not

func isPalindrome(string: String) -> Bool {
    let array = Array(string.lowercased())
    for index in 0..<array.count / 2 {
        if array[index] != array[array.count - 1 - index] {
            print("\(string) isn't a palindrome")
            return false
        }
    }
    
    print("\(string) is a palindrome")
    return true
}

isPalindrome(string: "Level")
