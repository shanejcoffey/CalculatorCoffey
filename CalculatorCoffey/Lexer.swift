//
//  Lexer.swift
//  CalculatorCoffey
//
//  Created by SHANE COFFEY on 2/15/26.
//

import Foundation

enum LexerError: LocalizedError {
    case unexpectedCharacter(char: Character, position: Int)
    
    var errorDescription: String? {
        switch self {
        case .unexpectedCharacter(let char, let position):
            return "Unexpected character '\(char)' at position \(position)"
        }
    }
}

class Lexer {
    var text: String
    var pos = 0
    
    var currChar: Character? {
        if pos >= text.count {
            return nil
        }
        return text[text.index(text.startIndex, offsetBy: pos)]
    }
    
    init(_ text: String) {
        self.text = text
    }
    
    private func advance() {
        pos += 1
    }
    
    // is this good or should i change peek?
    private func peek() -> Character? {
        if pos + 1 < text.count {
            return text[text.index(text.startIndex, offsetBy: pos + 1)]
        }
        return nil
    }
    
    private func skipWhitespace() {
        while let ch = currChar, ch.isWhitespace {
            advance()
        }
    }
    
    private func number() -> Double {
        var num = 0.0
        while let ch = currChar, ch.isNumber {
            num = num * 10 + Double(ch.wholeNumberValue!)
            advance()
        }
        if let decimalChar = currChar, decimalChar == "." {
            var numDecimals = 1.0
            advance()
            while let ch = currChar, ch.isNumber {
                num += pow(0.1, numDecimals) * Double(ch.wholeNumberValue!)
                numDecimals += 1
                advance()
            }
        }
        return num
    }
    
    func getNextToken() throws -> Token {
        skipWhitespace()
        
        guard let ch = currChar else {
            return Token(type: .eof, value: "", pos: pos)
        }
        
        if ch.isNumber || (ch == "." && peek()?.isNumber ?? false) {
            let p = pos
            return Token(type: .number, value: String(number()), pos: p)
        }
        
        if ch == "+" {
            advance()
            return Token(type: .plus, value: "+", pos: pos - 1)
        }
        
        if ch == "-" {
            advance()
            return Token(type: .minus, value: "-", pos: pos - 1)
        }
        
        if ch == "*" {
            advance()
            return Token(type: .multiply, value: "*", pos: pos - 1)
        }
        
        if ch == "/" {
            advance()
            return Token(type: .divide, value: "/", pos: pos - 1)
        }
        
        if ch == "(" {
            advance()
            return Token(type: .lParen, value: "(", pos: pos - 1)
        }
        
        if ch == ")" {
            advance()
            return Token(type: .rParen, value: ")", pos: pos - 1)
        }
        
        if ch == "^" {
            advance()
            return Token(type: .pow, value: "^", pos: pos - 1)
        }
        
        if ch.isLetter {
            advance()
            return Token(type: .variable, value: String(ch), pos: pos - 1)
        }
        
        throw LexerError.unexpectedCharacter(char: ch, position: pos)
    }
}
