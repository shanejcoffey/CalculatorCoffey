//
//  Node.swift
//  CalculatorCoffey
//
//  Created by SHANE COFFEY on 2/16/26.
//

import Foundation

protocol Visitable {
    func accept(_ visitor: Visitor) throws -> Double
}

class Node {
    var token: Token
    
    init(_ token: Token) {
        self.token = token
    }
}

class NumberNode: Node, Visitable {
    var value: Double
    override init(_ token: Token) {
        guard let v = Double(token.value) else {
            fatalError("Invalid number token value: \(token.value)")
        }
        value = v
        super.init(token)
    }
    
    func accept(_ visitor: NodeVisitor) throws -> Double {
        try visitor.visitNumber(self)
    }
}

class BinaryNode: Node, Visitable {
    var left: Node
    var right: Node
    
    init(_ token: Token, left: Node, right: Node) {
        self.left = left
        self.right = right
        super.init(token)
    }
    
    func accept(_ visitor: NodeVisitor) throws -> Double {
        try visitor.visitBinary(self)
    }
}
