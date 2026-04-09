//
//  File.swift
//  CalculatorCoffey
//
//  Created by SHANE COFFEY on 1/31/26.
//

import Foundation

enum ParserError: LocalizedError {
    case unexpectedTokenType(expected: TokenType, actual: TokenType, position: Int)
    
    var errorDescription: String? {
        switch self {
        case .unexpectedTokenType(let expected, let actual, let position):
            return "Syntax error at position \(position): expected \(expected), got \(actual)"
        }
    }
}

class Parser {
    var currentToken: Token
    let lexer: Lexer
    
    init(_ text: String) throws {
        lexer = Lexer(text)
        currentToken = try lexer.getNextToken()
    }
    
    private func eat(expected: TokenType) throws {
        if currentToken.type == expected {
            currentToken = try lexer.getNextToken()
        } else {
            throw ParserError.unexpectedTokenType(expected: expected, actual: currentToken.type, position: lexer.pos)
        }
    }
    
    private func arguments() throws -> [Node] {
        var args: [Node] = []
        
        try eat(expected: .lParen)
        
        if currentToken.type != .rParen {
            args.append(try expr())
            while currentToken.type == .comma {
                try eat(expected: .comma)
                args.append(try expr())
            }
        }
        
        try eat(expected: .rParen)
        
        return args
    }
    
    private func factor() throws -> Node {
        switch currentToken.type {
            
        case let type where type.isAddOperator:
            let token = currentToken
            try eat(expected: type)
            return UnaryNode(token, node: try factor())
            
        case .number:
            let token = currentToken
            try eat(expected: .number)
            return NumberNode(token)
            
        case .variable:
            let token = currentToken
            try eat(expected: .variable)
            return VariableNode(token)
            
        case .lParen:
            try eat(expected: .lParen)
            let node = try expr()
            try eat(expected: .rParen)
            return node
            
        case .function:
            let token = currentToken
            try eat(expected: .function)
            let args = try arguments()
            return FunctionNode(token, args: args)
            
        default:
            return Node(Token(type: .divide, value: "DIVIDE"))
            // throw ParserError.unexpectedTokenType(expected: .number, actual: type, position: lexer.pos)
            
        }
    }
    
    private func power() throws -> Node {
        let node = try factor()
        
        if currentToken.type == .pow {
            let operatorToken = currentToken
            try eat(expected: .pow)
            return BinaryNode(operatorToken, left: node, right: try power())
        }
        
        return node
    }
    
    private func term() throws -> Node {
        var node = try power()
        while currentToken.type.isMulOperator {
            let operatorToken = currentToken
            try eat(expected: operatorToken.type)
            node = BinaryNode(operatorToken, left: node, right: try power())
        }
        
        return node
    }
    
    private func expr() throws -> Node {
        var node = try term()
        while currentToken.type.isAddOperator {
            let operatorToken = currentToken
            try eat(expected: operatorToken.type)
            node = BinaryNode(operatorToken, left: node, right: try term())
        }
        
        return node
    }
    
    func parse() throws -> Node {
        let node = try expr()
        try eat(expected: .eof)
        return node
    }
}
