//
//  File.swift
//  CalculatorCoffey
//
//  Created by SHANE COFFEY on 1/31/26.
//

import Foundation

enum TokenType: String {
    case integer = "INTEGER"
    case plus = "PLUS"
    case eof = "EOF"
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
