//
//  AxisRatingBar.swift
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

public struct AxisRatingBar<B, F>: View where B: View, F: View {
    
    /// Bind values according to ARValueMode.
    @Binding private var value: CGFloat
    
    /// Settings that define the rating bar.
    private var constant: ARConstant
    
    /// A view builder for background views.
    @ViewBuilder private var backV: () -> B
    
    /// A view builder for foreground views.
    @ViewBuilder private var foreV: () -> F
    
    public var body: some View {
        ZStack(alignment: .topLeading) {
            backgroundView
            foregroundView.mask(maskView)
        }
        .gesture(constant.disabled ? nil : dragGesture)
        .animation(constant.animation, value: value)
    }
    
    //MARK: - Properties
    
    /// Replaces a value with a value between 0 and 1.
    private var ratioValue: CGFloat {
        if constant.valueMode == .point {
            return value / CGFloat(constant.rating)
        }
        return value
    }
    
    /// The drag gesture on the rating bar.
    private var dragGesture: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { value in
                self.setLocation(constant.axisMode == .horizontal ? value.location.x : value.location.y)
            }
            .onEnded { value in
                self.setLocation(constant.axisMode == .horizontal ? value.location.x : value.location.y)
            }
    }
    
    /// Depending on the axis mode, it is the horizontal or vertical size of the rating bar.
    private var barSize: CGFloat {
        if constant.axisMode == .horizontal {
            return CGFloat(constant.rating) * (constant.size.width + constant.spacing)
        }else {
            return CGFloat(constant.rating) * (constant.size.height + constant.spacing)
        }
    }
    
    /// The background view according to the axis mode.
    private var backgroundView: some View {
        var views: some View {
            ForEach(0..<constant.rating, id: \.self) { index in
                HStack(alignment: .center) {
                    backV().frame(width: constant.size.width, height: constant.size.height)
                }
            }
        }
        return ZStack {
            if constant.axisMode == .horizontal {
                HStack(spacing: 0) {
                    views
                        .frame(width: constant.size.width + constant.spacing, height: constant.size.height)
                }
                .frame(width: barSize)
            }else {
                VStack(spacing: 0) {
                    views
                        .frame(width: constant.size.width, height: constant.size.height + constant.spacing)
                }
                .frame(height: barSize)
            }
        }
        .contentShape(Rectangle())
    }
    
    /// The foreground view according to the axis mode.
    private var foregroundView: some View {
        var views: some View {
            ForEach(0..<constant.rating, id: \.self) { index in
                HStack(alignment: .center) {
                    foreV().frame(width: constant.size.width, height: constant.size.height)
                }
            }
        }
        return ZStack {
            if constant.axisMode == .horizontal {
                HStack(spacing: 0) {
                    views
                        .frame(width: constant.size.width + constant.spacing, height: constant.size.height)
                }
                .frame(width: barSize)
            }else {
                VStack(spacing: 0) {
                    views
                        .frame(width: constant.size.width, height: constant.size.height + constant.spacing)
                }
                .frame(height: barSize)
            }
        }
        .contentShape(Rectangle())
    }
    
    /// The mask view to apply to the foreground.
    private var maskView: some View {
        Rectangle()
            .fill(Color.white)
            .scaleEffect(constant.axisMode == .horizontal ? CGSize(width: ratioValue, height: 1) : CGSize(width: 1, height: ratioValue), anchor: constant.axisMode == .horizontal ? .leading : .bottom)
    }
    
    //MARK: - Methods
    
    /// Converts gesture position to value according to axis mode.
    /// - Parameter v: The value of the gesture's current position.
    private func setLocation(_ v: CGFloat) {
        var value = constant.axisMode == .horizontal ? (v / barSize) : ((barSize - v) / barSize)
        DispatchQueue.main.async {
            switch constant.fillMode {
            case .half:
                value = CGFloat(Int(CGFloat((constant.rating * 2) + 1) * value))
                value = value / CGFloat(constant.rating * 2)
            case .full:
                value = CGFloat(Int(CGFloat(constant.rating + 1) * value))
                value = value / CGFloat(constant.rating)
            case .precise: break
            }
            
            value = max(0, value)
            value = min(1, value)
            
            if constant.valueMode == .point {
                self.value = value * CGFloat(constant.rating)
            }else {
                self.value = value
            }
        }
    }
}

public extension AxisRatingBar where B : View, F : View  {
    
    /// Initializes `AxisRatingBar`
    /// - Parameters:
    ///   - value: Bind values according to ARValueMode.
    ///   - constant: Settings that define the rating bar.
    ///   - background: A view builder for background views.
    ///   - foreground: A view builder for foreground views.
    init(value: Binding<CGFloat>, constant: ARConstant = .init(), @ViewBuilder background: @escaping () -> B, @ViewBuilder foreground: @escaping () -> F) {
        _value = value
        self.constant = constant
        self.backV = background
        self.foreV = foreground
    }
}

struct AxisRatingBar_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            AxisRatingBar(value: .constant(0.5), constant: .init()) {
                ARStar(count: 6, innerRatio: 1)
                    .fill(Color.gray)
            } foreground: {
                ARStar(count: 6, innerRatio: 1)
                    .fill(Color.accentColor)
            }
            
            AxisRatingBar(value: .constant(0.5), constant: .init(axisMode: .vertical)) {
                ARStar(count: 6, innerRatio: 1)
                    .fill(Color.gray)
            } foreground: {
                ARStar(count: 6, innerRatio: 1)
                    .fill(Color.accentColor)
            }
        }
    }
}
