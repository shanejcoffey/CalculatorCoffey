//
//  File.swift
//  CalculatorCoffey
//
//  Created by SHANE COFFEY on 1/31/26.
//

import Foundation

enum TokenType: String {
    case number = "NUMBER"
    case plus = "PLUS"
    case eof = "EOF"
    case minus = "MINUS"
    case multiply = "MUL"
    case divide = "DIV"
    case lParen = "LPAREN"
    case rParen = "RPAREN"
    case pow = "POW"
}

extension TokenType {
    var isAddOperator: Bool {
        self == .plus || self == .minus
    }
    
    var isMulOperator: Bool {
        self == .multiply || self == .divide
    }
}

class Token {
    let type: TokenType
    let value: String
    
    var info: String {
        return "Token(\(type), \(value))"
    }
    
    init(type: TokenType, value: String) {
        self.type = type
        self.value = value
    }
}
