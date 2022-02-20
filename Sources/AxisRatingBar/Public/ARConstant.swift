//
//  ARConstant.swift
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

/// Defines how the view is filled when the rating is not an integer number.
public enum ARFillMode {
    /// Shows only fully populated views.
    case full
    /// Shows fully-filled and half-filled views.
    case half
    /// Displays views according to exact percentages.
    case precise
}

/// Defines the horizontal/vertical orientation of the rating bar.
public enum ARAxisMode {
    /// Display the view horizontally.
    case horizontal
    /// Displays the view vertically.
    case vertical
}

/// The mode of the filled value.
public enum ARValueMode {
    /// A value between 0 and 1
    case ratio
    /// A value between 0 and rating.
    case point
}

/// Settings that define the rating bar.
public struct ARConstant: Equatable {
    
    /// The number of views filled is typically between 1 and 5. The view is displayed according to the fill mode setting.
    public var rating: Int
    
    /// The size of the individual view.
    public var size: CGSize
    
    /// The spacing between the view and the view.
    public var spacing: CGFloat
    
    /// Defines how the view is filled when the rating is not an integer number.
    public var fillMode: ARFillMode
    
    /// Defines the horizontal/vertical orientation of the rating bar.
    public var axisMode: ARAxisMode
    
    /// The mode of the filled value.
    public var valueMode: ARValueMode
    
    /// A condition that controls whether users can interact with rating bar.
    public var disabled: Bool
    
    /// The animation effect of the view being filled.
    public var animation: Animation?
    
    /// Initializes `ARConstant`
    /// - Parameters:
    ///   - rating: The number of views filled is typically between 1 and 5. The view is displayed according to the fill mode setting. The default value is `5`.
    ///   - size: The size of the individual view. The default value is `CGSize(width: 44, height: 44)`.
    ///   - spacing: The spacing between the view and the view. The default value is `0`
    ///   - fillMode: Defines how the view is filled when the rating is not an integer number. The default value is `.half`.
    ///   - axisMode: Defines the horizontal/vertical orientation of the rating bar. The default value is `.horizontal`.
    ///   - valueMode: The mode of the filled value. The default value is `.ratio`
    ///   - disabled: A condition that controls whether users can interact with rating bar. The default value is 'false'
    ///   - animation: The animation effect of the view being filled. The default value is `.easeOut(duration: 0.16)`
    public init(rating: Int = 5,
                size: CGSize = CGSize(width: 44, height: 44),
                spacing: CGFloat = 0,
                fillMode: ARFillMode = .half,
                axisMode: ARAxisMode = .horizontal,
                valueMode: ARValueMode = .ratio,
                disabled: Bool = false,
                animation: Animation? = .easeOut(duration: 0.16)) {
        self.rating = rating
        self.size = size
        self.spacing = spacing
        self.fillMode = fillMode
        self.axisMode = axisMode
        self.valueMode = valueMode
        self.disabled = disabled
        self.animation = animation
    }
}
