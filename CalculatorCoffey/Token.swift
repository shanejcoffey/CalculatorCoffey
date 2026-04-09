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
    case variable = "VAR"
    case function = "FUNC"
    case comma = "COMMA"
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
    let pos: Int
    
    var info: String {
        return "Token(\(type), \(value))"
    }
    
    init(type: TokenType, value: String, pos: Int = -1) {
        self.type = type
        self.value = value
        self.pos = pos
    }
}
