//
//  TrapezoidShape.swift
//  WallpaperIOS
//
//  Created by Duc on 16/10/2023.
//

import SwiftUI

struct TrapezoidShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
                
                // Define the corner points of the inverted trapezoid
                let startPoint = CGPoint(x: 0, y: rect.minY)
                let topRightPoint = CGPoint(x: rect.maxX, y: rect.minY)
                let bottomRightPoint = CGPoint(x: rect.maxX * 0.6, y: rect.maxY)
                let endPoint = CGPoint(x: rect.maxX * 0.4, y: rect.maxY)
                
                // Start the path at the starting point
                path.move(to: startPoint)
                
                // Draw lines to the other points to form the inverted trapezoid
                path.addLine(to: topRightPoint)
                path.addLine(to: bottomRightPoint)
                path.addLine(to: endPoint)
                
                // Close the path to complete the shape
                path.closeSubpath()
                
                return path
    }
}

struct XXX: View {
    var body: some View {
        TrapezoidShape()
            .fill(Color.blue)  // Fill the trapezoid shape with blue color
            .frame(width: 200, height: 100)  // Set the size of the shape
    }
}

#Preview {
    XXX()
}


struct BottomClippedModifier: ViewModifier {
    func body(content: Content) -> some View {
        GeometryReader { geometry in
            content
                .clipShape(BottomClipShape(bottomOffset: geometry.size.height * 0.1))
        }
    }
}

struct BottomClipShape: Shape {
    let bottomOffset: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.addRect(CGRect(x: rect.minX, y: rect.minY, width: rect.width, height: rect.height - bottomOffset))

        return path
    }
}
