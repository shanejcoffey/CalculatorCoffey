//
//  CalculatorCoffeyTests.swift
//  CalculatorCoffeyTests
//
//  Created by SHANE COFFEY on 1/28/26.
//

import Testing
@testable import CalculatorCoffey

struct CalculatorCoffeyTests {

    @Test
    func example() async throws {
        let tests: [(input: String, output: Double, shouldError: Bool)] = [
            ("1", 1, false),
            ("1.1", 1.1, false),
            ("123.3456", 123.3456, false),
            ("+", 0, true),
            ("1 +  ", 0, true),
            ("1 + .", 0, true),
            ("1 + 1", 2, false),
            ("133 + 45", 178, false),
            ("1.13 + 90.11", 91.24, false),
            ("1. + .1", 1.1, false),
            ("3 - 1", 2, false),
        ]
        
        for t in tests {
            do {
                let interpreter = try Interpreter(t.input)
                let result = try interpreter.interpret()
                #expect(!t.shouldError, "Unexpected success for \(t.input)")
                #expect(result == t.output, "Unexpected result for \(t.input): \(result), expected \(t.output)")
            } catch {
                #expect(t.shouldError, "Unexpected error for \(t.input)")
            }
        }
    }

}
