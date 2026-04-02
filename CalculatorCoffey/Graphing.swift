//
//  Graphing.swift
//  CalculatorCoffey
//
//  Created by SHANE COFFEY on 3/23/26.
//

import Foundation

class Graphing {
    
    static let epsilon = 1e-9
    
    static func MarchingSquares(minX: Double, minY: Double, maxX: Double, maxY: Double, resolution: Int, left: String, right: String) -> [[[Double]]] {
        
        let xStep = (maxX - minX) / Double(resolution)
        let yStep = (maxY - minY) / Double(resolution)
        var on = Array(repeating: Array(repeating: false, count: resolution + 1), count: resolution + 1)
        
        for i in 0...resolution {
            print("\(i)")
            let x = minX + Double(i) * xStep
            for j in 0...resolution {
                let y = minY + Double(j) * yStep
                
                var leftVal: Double
                var rightVal: Double
                do {
                    let varDict = ["x": x, "y": y]
                    leftVal = try Interpreter(left, variables: varDict).interpret()
                    rightVal = try Interpreter(right, variables: varDict).interpret()
                } catch(let e) {
                    print(e)
                    return []
                }
                
                on[j][i] = leftVal >= rightVal
            }
        }
        
        var segments: [[[Double]]] = []
        
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
                
                let l = [roundWithEpsilon(x), roundWithEpsilon(y + 0.5 * yStep)]
                let r = [roundWithEpsilon(x + xStep), roundWithEpsilon(y + 0.5 * yStep)]
                let b = [roundWithEpsilon(x + 0.5 * xStep), roundWithEpsilon(y)]
                let t = [roundWithEpsilon(x + 0.5 * xStep), roundWithEpsilon(y + yStep)]
                
                switch num {
                case 1, 14:
                    segments.append([l, b])
                case 2, 13:
                    segments.append([b, r])
                case 3, 12:
                    segments.append([l, r])
                case 4, 11:
                    segments.append([t, r])
                case 5:
                    segments.append([l, b])
                    segments.append([t, r])
                case 6, 9:
                    segments.append([t, b])
                case 7, 8:
                    segments.append([l, t])
                case 10:
                    segments.append([l, t])
                    segments.append([b, r])
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
}

struct Point {
    let x: Double
    let y: Double
}
