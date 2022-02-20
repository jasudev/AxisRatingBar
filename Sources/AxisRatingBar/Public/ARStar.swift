//
//  ARStar.swift
//  AxisRatingBar
//
//  Created by jasu on 2022/02/20.
//  Copyright (c) 2022 jasu All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is furnished
//  to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
//  INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
//  PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
//  CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
//  OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

import SwiftUI

/// A star shape.
public struct ARStar: Shape {
    
    var count: CGFloat
    var innerRatio: CGFloat
    
    public var animatableData: AnimatablePair<CGFloat, CGFloat> {
        get { AnimatablePair(count, innerRatio) }
        set {
            count = newValue.first
            innerRatio = newValue.second
        }
    }
    
    public init(count: CGFloat, innerRatio: CGFloat) {
        self.count = count
        self.innerRatio = innerRatio
    }
    
    public func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.width * 0.5, y: rect.height * 0.5)
        let pointAngle = .pi / count
        
        let innerPoint = CGPoint(x: center.x * innerRatio * 0.5, y: center.y * innerRatio * 0.5)
        let totalPoints = Int(count * 2.0)
        
        var currentAngle = CGFloat.pi * -0.5
        var currentBottom: CGFloat = 0
        
        var path = Path()
        path.move(to: CGPoint(x: center.x * cos(currentAngle),
                              y: center.y * sin(currentAngle)))
        
        let correction = count != round(count) ? 1 : 0
        for corner in 0..<totalPoints + correction  {
            var bottom: CGFloat = 0
            let sin = sin(currentAngle)
            let cos = cos(currentAngle)
            if (corner % 2) == 0 {
                bottom = center.y * sin
                path.addLine(to: CGPoint(x: center.x * cos, y: bottom))
            } else {
                bottom = innerPoint.y * sin
                path.addLine(to: CGPoint(x: innerPoint.x * cos, y: bottom))
            }
            currentBottom = max(bottom, currentBottom)
            currentAngle += pointAngle
        }
        path.closeSubpath()
        let transform = CGAffineTransform(translationX: center.x, y: center.y + ((rect.height * 0.5 - currentBottom) * 0.5))
        return path.applying(transform)
    }
}


struct ARStar_Previews: PreviewProvider {
    static var previews: some View {
        ARStar(count: 5, innerRatio: 1)
            .frame(width: 200, height: 200)
    }
}
