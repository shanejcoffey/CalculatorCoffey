//
//  Node.swift
//  CalculatorCoffey
//
//  Created by SHANE COFFEY on 2/16/26.
//

import Foundation

protocol Visitable {
    func accept(_ interpreter: Interpreter) throws -> Double
}

class Node: Visitable {
    let token: Token
    
    init(_ token: Token) {
        self.token = token
    }
    
    func accept(_ interpreter: Interpreter) throws -> Double {
        fatalError("Node didn't implement accept")
    }
}

class NumberNode: Node {
    let value: Double
    override init(_ token: Token) {
        guard let v = Double(token.value) else {
            fatalError("Invalid number token value: \(token.value)")
        }
        value = v
        super.init(token)
    }
    
    override func accept(_ visitor: Interpreter) throws -> Double {
        visitor.visitNumber(self)
    }
}

class VariableNode: Node {
    override init(_ token: Token) {
        super.init(token)
    }
    
    override func accept(_ visitor: Interpreter) throws -> Double {
        try visitor.visitVariable(self)
    }
}

class UnaryNode: Node {
    let node: Node
    
    init(_ token: Token, node: Node) {
        self.node = node
        super.init(token)
    }
    
    override func accept(_ visitor: Interpreter) throws -> Double {
        try visitor.visitUnary(self)
    }
}

class BinaryNode: Node {
    let left: Node
    let right: Node
    
    init(_ token: Token, left: Node, right: Node) {
        self.left = left
        self.right = right
        super.init(token)
    }
    
    override func accept(_ visitor: Interpreter) throws -> Double {
        try visitor.visitBinary(self)
    }
}

class FunctionNode: Node {
    let name: String
    let args: [Node]
    
    init(_ token: Token, args: [Node]) {
        self.name = token.value
        self.args = args
        super.init(token)
    }
    
    override func accept(_ visitor: Interpreter) throws -> Double {
        try visitor.visitFunction(self)
    }
}
