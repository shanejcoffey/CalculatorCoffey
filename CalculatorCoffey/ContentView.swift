//
//  ContentView.swift
//  CalculatorCoffey
//
//  Created by SHANE COFFEY on 1/28/26.
//

import SwiftUI

struct ContentView: View {
    @State var text = ""
    @State var result = ""
    var body: some View {
        VStack {
            TextField("Enter equation", text: $text)
            Button("calculate") {
                do {
                    let interpreter = try Interpreter(text)
                    let value = try interpreter.interpret()
                    result = "\(value)"
                } catch let error as ParserError {
                    result = error.errorDescription ?? "idk what happened"
                } catch let error as LexerError {
                    result = error.errorDescription ?? "idk what happened"
                } catch let error as InterpreterError {
                    result = error.errorDescription ?? "idk what happened"
                } catch {
                    result = "Unknown error"
                }
            }
            Text(result)
        }
    }
}

#Preview {
    ContentView()
}
