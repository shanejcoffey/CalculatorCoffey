//
//  GraphView.swift
//  CalculatorCoffey
//
//  Created by SHANE COFFEY on 3/23/26.
//

import SwiftUI

struct GraphView: View {
    let segments: [LineSegment]
    let minX: Double
    let maxX: Double
    let minY: Double
    let maxY: Double

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                
                let widthRatio = geometry.size.width / CGFloat(maxX - minX)
                let heightRatio = geometry.size.height / CGFloat(maxY - minY)
                let scale = min(widthRatio, heightRatio)
                
                let xOffset = (geometry.size.width - CGFloat(maxX - minX) * scale) / 2
                let yOffset = (geometry.size.height - CGFloat(maxY - minY) * scale) / 2
                
                Path { path in
                    let xAxis = geometry.size.height - (yOffset + CGFloat(0 - minY) * scale)
                    path.move(to: CGPoint(x: xOffset, y: xAxis))
                    path.addLine(to: CGPoint(x: geometry.size.width - xOffset, y: xAxis))
                    
                    let yAxis = xOffset + CGFloat(0 - minX) * scale
                    path.move(to: CGPoint(x: yAxis, y: yOffset))
                    path.addLine(to: CGPoint(x: yAxis, y: geometry.size.height - yOffset))
                }
                .stroke(Color.gray, lineWidth: 1)
                
                Path { path in
                    for s in segments {
                        let p1 = s.start
                        let p2 = s.end
                        
                        let x1 = xOffset + CGFloat(p1.x - minX) * scale
                        let y1 = geometry.size.height - (yOffset + CGFloat(p1.y - minY) * scale)
                        let x2 = xOffset + CGFloat(p2.x - minX) * scale
                        let y2 = geometry.size.height - (yOffset + CGFloat(p2.y - minY) * scale)
                        
                        path.move(to: CGPoint(x: x1, y: y1))
                        path.addLine(to: CGPoint(x: x2, y: y2))
                    }
                }
                .stroke(Color.red, lineWidth: 1)
            }
        }
    }
}
