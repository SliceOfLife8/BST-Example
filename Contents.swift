import UIKit

// MARK: - Create random list of integers in range 1-100
func makeList(_ n: Int) -> [Int] {
    return (0..<n).map{ _ in Int.random(in: 1 ... 100) }
}
/// Create a random range (5-10) list of random integers
let randomList = makeList(Int.random(in: 5 ... 10))
let list: [Int] = [21, 17, 33, 27, 15, 19]

let randomTree = BinarySearchTree(array: randomList)
let tree = BinarySearchTree(array: list)

let newRandomTree = randomTree.search(value: randomList.randomElement() ?? 0)
let newTree = tree.search(value: 17)
