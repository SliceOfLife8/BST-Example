import Foundation

public class BinarySearchTree<T: Comparable> {
    // MARK: Stored properties
    private(set) public var value: T
    private(set) public var parent: BinarySearchTree?
    private(set) public var left: BinarySearchTree?
    private(set) public var right: BinarySearchTree?
    
    // MARK: Initializers
    public init(value: T) {
        self.value = value
    }
    
    convenience public init(array: [T]) {
        precondition(array.count > 0)
        self.init(value: array.first!)
        for value in array.dropFirst() {
            insert(value: value)
        }
    }
    
    // MARK: Computed properties
    var isRoot: Bool {
        return parent == nil
    }
    
    var isLeaf: Bool {
        return left == nil && right == nil
    }
    
    var isLeftChild: Bool {
        return parent?.left === self
    }
    
    var isRightChild: Bool {
        return parent?.right === self
    }
    
    var hasLeftChild: Bool {
        return left != nil
    }
    
    var hasRightChild: Bool {
        return right != nil
    }
    
    var hasAnyChild: Bool {
        return hasLeftChild || hasRightChild
    }
    
    var hasBothChildren: Bool {
        return hasLeftChild && hasRightChild
    }
    
    var count: Int {
        return (left?.count ?? 0) + 1 + (right?.count ?? 0)
    }
    
    // MARK: Tree's operations
    public func insert(value: T) {
        if value < self.value {
            if let left = left {
                left.insert(value: value)
            } else {
                left = BinarySearchTree(value: value)
                left?.parent = self
            }
        } else {
            if let right = right {
                right.insert(value: value)
            } else {
                right = BinarySearchTree(value: value)
                right?.parent = self
            }
        }
    }
    
    public func search(value: T) -> BinarySearchTree? {
        if value < self.value {
            return left?.search(value: value)
        } else if value > self.value {
            return right?.search(value: value)
        } else {
            return self
        }
    }
    
    func traverse(type: TraverseType, process: (T) -> Void) {
        switch type {
        case .inOrder:
            traverseInOrder(process: process)
        case .preOrder:
            traversePreOrder(process: process)
        case .postOrder:
            traversePostOrder(process: process)
        }
    }
    
    @discardableResult
    public func remove() -> BinarySearchTree? {
        let replacement: BinarySearchTree?
        
        if let right = right {
            replacement = right.minimum()
        } else if let left = left {
            replacement = left.maximum()
        } else {
            replacement = nil
        }
        
        replacement?.remove()
        
        replacement?.right = right
        replacement?.left = left
        right?.parent = replacement
        left?.parent = replacement
        reconnectParent(to: replacement)
        
        parent = nil
        left = nil
        right = nil
        
        return replacement
    }
    
    func depth() -> Int {
        var node = self
        var edges = 0
        
        while let parent = node.parent {
            node = parent
            edges += 1
        }
        return edges
    }
    
    func height() -> Int {
        if isLeaf {
            return 0
        } else {
            return 1 + max(left?.height() ?? 0, right?.height() ?? 0)
        }
    }
    
    func predecessor() -> BinarySearchTree? {
        if let left = left {
            return left.maximum()
        } else {
            var node = self
            while let parent = node.parent {
                if parent.value < value {
                    return parent
                }
                node = parent
            }
            return nil
        }
    }
    
    func successor() -> BinarySearchTree<T>? {
        if let right = right {
            return right.minimum()
        } else {
            var node = self
            while let parent = node.parent {
                if parent.value > value { return parent }
                node = parent
            }
            return nil
        }
    }
    
    func isValidBST(minValue: T, maxValue: T) -> Bool {
        if value < minValue || value > maxValue { return false }
        let leftBranch = left?.isValidBST(minValue: minValue, maxValue: value) ?? true
        let rightBranch = right?.isValidBST(minValue: value, maxValue: maxValue) ?? true
        return leftBranch && rightBranch
    }
    
}

// MARK: Traversing helpers method
extension BinarySearchTree {
    enum TraverseType {
        case inOrder
        case preOrder
        case postOrder
    }
    
    private func traverseInOrder(process: (T) -> Void) {
        left?.traverseInOrder(process: process)
        process(value)
        right?.traverseInOrder(process: process)
    }
    
    private func traversePreOrder(process: (T) -> Void) {
        process(value)
        left?.traversePreOrder(process: process)
        right?.traversePreOrder(process: process)
    }
    
    private func traversePostOrder(process: (T) -> Void) {
        left?.traversePostOrder(process: process)
        right?.traversePostOrder(process: process)
        process(value)
    }
}

// MARK: Remove's helpers
extension BinarySearchTree {
    func reconnectParent(to node: BinarySearchTree?) {
        if let parent = parent {
            if isLeftChild {
                parent.left = node
            } else {
                parent.right = node
            }
        }
        node?.parent = parent
    }
    
    func minimum() -> BinarySearchTree {
        var node = self
        while let prevNode = node.left {
            node = prevNode
        }
        return node
    }
    
    func maximum() -> BinarySearchTree {
        var node = self
        while let nextNode = node.right {
            node = nextNode
        }
        return node
    }
}

// MARK: Debug Print
extension BinarySearchTree: CustomStringConvertible {
    public var description: String {
        var s = ""
        if let left = left {
            s += "(\(left.description)) <- "
        }
        s += "\(value)"
        if let right = right {
            s += " -> (\(right.description))"
        }
        return s
    }
}
