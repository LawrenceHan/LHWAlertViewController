//
//  LHWAlertAction.swift
//  LHWAlertViewControllerDemo
//
//  Created by Shardul Patel on 18/01/17.
//  Copyright © 2017 Codigami Inc. All rights reserved.
//
//
//  LHWAlertAction.swift
//  LHWAlertViewController
//
//  Created by Hanguang on 28/03/2017.
//  Copyright © 2017 Hanguang. All rights reserved.
//
// Copyright (c) 2017年 Hanguang
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit

public class LHWAlertAction {
    
    // MARK: - Declarations
    public typealias LHWAlertActionHandlerBlock = (_ action: LHWAlertAction) -> Void
    
    public enum LHWAlertActionStyle: Int {
        case defaultStyle = 0
        case cancel
        case destructive
    }
    
    public enum LHWAlertActionAlignment: Int {
        case justified = 0
        case right
        case left
        case center
    }
    
    // MARK: - Variables
    public var title: String?
    public var style: LHWAlertActionStyle = .defaultStyle
    public var alignment: LHWAlertActionAlignment = .justified
    public var backgroundColor: UIColor?
    public var textColor: UIColor?
    public var handler: LHWAlertActionHandlerBlock?
    
    
    // MARK: - Initialisation Method
    public class func action(title: String?, style: LHWAlertActionStyle, alignment: LHWAlertActionAlignment, backgroundColor: UIColor?, textColor: UIColor?, handler: LHWAlertActionHandlerBlock?) -> LHWAlertAction {
        
        let action = LHWAlertAction.init()
        
        // Set Alert Properties
        action.title = title
        action.style = style
        action.alignment = alignment
        action.backgroundColor = backgroundColor
        action.textColor = textColor
        action.handler = handler
        
        return action
    }
}

