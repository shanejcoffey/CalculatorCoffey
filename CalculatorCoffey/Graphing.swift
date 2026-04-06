//
//  Graphing.swift
//  CalculatorCoffey
//
//  Created by SHANE COFFEY on 3/23/26.
//

import Foundation

class Graphing {
    
    static let epsilon = 1e-9
    
    static func MarchingSquares(minX: Double, minY: Double, maxX: Double, maxY: Double, resolution: Int, left: String, right: String) -> [LineSegment] {
        
        let xStep = (maxX - minX) / Double(resolution)
        let yStep = (maxY - minY) / Double(resolution)
        var on = Array(repeating: Array(repeating: false, count: resolution + 1), count: resolution + 1)
        
        
        let interpreter: Interpreter
        do {
            try interpreter = Interpreter("\(left) - (\(right))", variables: [:])
        } catch(let e) {
            print(e)
            return []
        }
        
        for i in 0...resolution {
            print("\(i)")
            interpreter.variables["x"] = minX + Double(i) * xStep
            for j in 0...resolution {
                interpreter.variables["y"] = minY + Double(j) * yStep
                
                var val: Double
                do {
                    val = try interpreter.interpret()
                } catch(let e) {
                    print(e)
                    return []
                }
                
                on[j][i] = val >= 0
            }
        }
        
        var segments: [LineSegment] = []
        
        for i in 0..<resolution {
            let x = minX + Double(i) * xStep
            for j in 0..<resolution {
                let y = minY + Double(j) * yStep
                
                let bL = on[j][i]
                let bR = on[j][i+1]
                let tL = on[j+1][i]
                let tR = on[j+1][i+1]
                
                var num = 0
                if tL { num += 8 }
                if tR { num += 4 }
                if bR { num += 2 }
                if bL { num += 1 }
                
                let l = Point(roundWithEpsilon(x), roundWithEpsilon(y + 0.5 * yStep))
                let r = Point(roundWithEpsilon(x + xStep), roundWithEpsilon(y + 0.5 * yStep))
                let b = Point(roundWithEpsilon(x + 0.5 * xStep), roundWithEpsilon(y))
                let t = Point(roundWithEpsilon(x + 0.5 * xStep), roundWithEpsilon(y + yStep))
                
                switch num {
                case 1, 14:
                    segments.append(LineSegment(l, b))
                case 2, 13:
                    segments.append(LineSegment(b, r))
                case 3, 12:
                    segments.append(LineSegment(l, r))
                case 4, 11:
                    segments.append(LineSegment(t, r))
                case 5:
                    segments.append(LineSegment(l, b))
                    segments.append(LineSegment(t, r))
                case 6, 9:
                    segments.append(LineSegment(t, b))
                case 7, 8:
                    segments.append(LineSegment(l, t))
                case 10:
                    segments.append(LineSegment(l, t))
                    segments.append(LineSegment(b, r))
                default: break
                }
            }
        }
        print("done getting points")
        return segments
    }
    
    static func roundWithEpsilon(_ x: Double) -> Double {
        return (x / epsilon).rounded() * epsilon
    }
}

struct LineSegment {
    let start: Point
    let end: Point
    
    init(_ start: Point, _ end: Point) {
        self.start = start
        self.end = end
    }
}

struct Point {
    let x: Double
    let y: Double
    
    init(_ x: Double, _ y: Double) {
        self.x = x
        self.y = y
    }
}
