//
//  Interpreter.swift
//  CalculatorCoffey
//
//  Created by SHANE COFFEY on 2/16/26.
//

import Foundation

enum InterpreterError: LocalizedError {
    case divideByZero(position: Int)
    
    var errorDescription: String? {
        switch self {
        case .divideByZero(let position):
            return "Tried to divide by zero at position \(position)"
        }
    }
}

class Interpreter {
    let parser: Parser
    
    init(_ text: String) throws {
        self.parser = try Parser(text)
    }
    
    func interpret() throws -> Double {
        let ast = try parser.parse()
        return try visit(ast)
    }
    
    private func visit(_ node: Node) throws -> Double {
        return try node.accept(self)
    }
    
    func visitNumber(_ node: NumberNode) -> Double {
        return node.value
    }
    
    func visitUnary(_ node: UnaryNode) throws -> Double {
        let val = try visit(node.node)
        
        switch node.token.type {
        case .plus:
            return val
        case .minus:
            return -val
        default:
            fatalError("Visited unary node with invalid operator: \(node.token.type)")
        }
    }
    
    func visitBinary(_ node: BinaryNode) throws -> Double {
        let left = try visit(node.left)
        let right = try visit(node.right)
        
        switch node.token.type {
        case .plus:
            return left + right
        case .minus:
            return left - right
        case .multiply:
            return left * right
        case .divide:
            if right == 0 {
                throw InterpreterError.divideByZero(position: parser.lexer.pos)
            }
            return left / right
        case .pow:
            return pow(left, right)
        default:
            fatalError("Visited BinaryNode with invalid operator: \(node.token.type)")
        }
    }
}
