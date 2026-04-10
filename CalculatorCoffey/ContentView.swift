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
    @State var graphText = ""
    
    @State var segments: [LineSegment] = []
    @State var minX: Double = -7
    @State var maxX: Double = 7
    @State var minY: Double = -10
    @State var maxY: Double = 10
    
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
            
            TextField("Enter graph", text: $graphText)
                .textInputAutocapitalization(.never)
            Button("get points") {
                print("graphing \(graphText)")
                let parts = graphText.split(separator: "=")
                guard parts.count == 2 else {
                    print("invalid equation")
                    return
                }
                segments = Graphing.MarchingSquares(
                    minX: minX,
                    minY: minY,
                    maxX: maxX,
                    maxY: maxY,
                    resolution: 500,
                    left: String(parts[0]),
                    right: String(parts[1])
                )
                
            }
            GraphView(
                segments: segments,
                minX: minX,
                maxX: maxX,
                minY: minY,
                maxY: maxY
            )
        }
        .onChange(of: graphText) { oldValue, newValue in
            print("graphing \(graphText)")
            let parts = graphText.split(separator: "=")
            guard parts.count == 2 else {
                print("invalid equation")
                return
            }
            
            segments = Graphing.MarchingSquares(
                minX: minX,
                minY: minY,
                maxX: maxX,
                maxY: maxY,
                resolution: 500,
                left: String(parts[0]),
                right: String(parts[1])
            )
            
        }
    }
}

#Preview {
    ContentView()
}
