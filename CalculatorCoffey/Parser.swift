//
//  File.swift
//  CalculatorCoffey
//
//  Created by SHANE COFFEY on 1/31/26.
//

import Foundation

enum InterpreterError: Error {
    case unexpectedTokenType(expected: TokenType, actual: TokenType, position: Int)
    
    var info: String {
        switch self {
        case .unexpectedTokenType(let expected, let actual, let position):
            return "Syntax error at position \(position): expected \(expected), got \(actual)"
        }
    }
}

class Interpreter {
    var currentToken: Token?
    var lexer: Lexer
    
    init(text: String) {
        lexer = Lexer(text)
        currentToken = try? lexer.getNextToken()
    }
    
    func eat(expected: TokenType) throws {
        if currentToken?.type == expected {
            currentToken = try lexer.getNextToken()
        } else {
            throw InterpreterError.unexpectedTokenType(expected: expected, actual: currentToken?.type ?? .eof, position: lexer.pos)
        }
    }
    
    func factor() throws -> Int {
        if currentToken?.type == .integer {
            guard let token = currentToken, let value = Int(token.value) else {
                throw InterpreterError.unexpectedTokenType(expected: .integer, actual: currentToken?.type ?? .eof, position: lexer.pos)
            }
            
            try eat(expected: .integer)
            return value
        } else if currentToken?.type == .lParen {
            try eat(expected: .lParen)
            let result = try expr()
            try eat(expected: .rParen)
            return result
        }
        throw InterpreterError.unexpectedTokenType(expected: .integer, actual: currentToken?.type ?? .eof, position: lexer.pos)
    }
    
    func term() throws -> Int {
        var result = try factor()
        
        while currentToken?.type == .multiply || currentToken?.type == .divide {
            if currentToken?.type == .multiply {
                try eat(expected: .multiply)
                result *= try factor()
            } else if currentToken?.type == .divide {
                try eat(expected: .divide)
                result /= try factor()
            }
        }
        
        return result
    }
    
    func expr() throws -> Int {
        var result = try term()
        
        while currentToken?.type == .plus || currentToken?.type == .minus {
            if currentToken?.type == .plus {
                try eat(expected: .plus)
                result += try term()
            } else if currentToken?.type == .minus {
                try eat(expected: .minus)
                result -= try term()
            }
        }
        
        return result
    }
}
