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
    
    private func factor() throws -> Node {
        let token = currentToken
        if token.type.isAddOperator {
            try eat(expected: token.type)
            return UnaryNode(token, node: try factor())
        } else if token.type == .number {
            try eat(expected: .number)
            return NumberNode(token)
        } else if token.type == .variable {
            try eat(expected: .variable)
            return VariableNode(token)
        } else if token.type == .lParen {
            try eat(expected: .lParen)
            let node = try expr()
            try eat(expected: .rParen)
            return node
        }
        throw ParserError.unexpectedTokenType(expected: .number, actual: token.type, position: lexer.pos)
    }
    
    private func power() throws -> Node {
        var node = try factor()
        while currentToken.type == .pow {
            let operatorToken = currentToken
            try eat(expected: .pow)
            node = BinaryNode(operatorToken, left: node, right: try factor())
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
