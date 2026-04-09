//
//  Interpreter.swift
//  CalculatorCoffey
//
//  Created by SHANE COFFEY on 2/16/26.
//

import Foundation

enum InterpreterError: LocalizedError {
    case divideByZero(position: Int)
    case unknownVariable(name: String, position: Int)
    case badArguments(name: String, position: Int)
    
    var errorDescription: String? {
        switch self {
        case .divideByZero(let position):
            return "Tried to divide by zero at position \(position)"
        case .unknownVariable(let name, let position):
            return "Unknown variable \(name) at position \(position)"
        case .badArguments(let name, let position):
            return "Bad arguments to \(name) at position \(position)"
        }
    }
}

class Interpreter {
    let ast: Node
    var variables: [String: Double]
    
    init(_ text: String, variables: [String: Double] = [:]) throws {
        let parser = try Parser(text)
        ast = try parser.parse()
        self.variables = variables
    }
    
    func interpret() throws -> Double {
        return try visit(ast)
    }
    
    private func visit(_ node: Node) throws -> Double {
        return try node.accept(self)
    }
    
    func visitNumber(_ node: NumberNode) -> Double {
        return node.value
    }
    
    func visitVariable(_ node: VariableNode) throws -> Double {
        guard let value = variables[node.token.value] else {
            throw InterpreterError.unknownVariable(name: node.token.value, position: node.token.pos)
        }
        return value
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
                throw InterpreterError.divideByZero(position: node.token.pos)
            }
            return left / right
        case .pow:
            return pow(left, right)
        default:
            fatalError("Visited BinaryNode with invalid operator: \(node.token.type)")
        }
    }
    
    func visitFunction(_ node: FunctionNode) throws -> Double {
        switch node.name {
        case "sin":
            guard node.args.count == 1 else {
                throw InterpreterError.badArguments(name: node.name, position: node.token.pos)
            }
            return sin(try visit(node.args[0]))
        
        case "cos":
            guard node.args.count == 1 else {
                throw InterpreterError.badArguments(name: node.name, position: node.token.pos)
            }
            return cos(try visit(node.args[0]))
            
        case "tan":
            guard node.args.count == 1 else {
                throw InterpreterError.badArguments(name: node.name, position: node.token.pos)
            }
            return tan(try visit(node.args[0]))
            
        case "log":
            guard node.args.count == 1 || node.args.count == 2 else {
                throw InterpreterError.badArguments(name: node.name, position: node.token.pos)
            }
            if node.args.count == 1 {
                return log10(try visit(node.args[0]))
            } else {
                return log2(try visit(node.args[1])) / log2(try visit(node.args[0]))
            }
        
        default:
            throw InterpreterError.unknownVariable(name: node.name, position: node.token.pos)
        }
    }
}
