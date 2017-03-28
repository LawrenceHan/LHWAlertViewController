//
//  LHWPushButton.swift
//  LHWAlertViewControllerDemo
//
//  Created by Shivam Bhalla on 1/18/17.
//  Copyright © 2017 Codigami Inc. All rights reserved.
//
//
//  LHWPushButton.swift
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

open class LHWPushButton: UIButton {
    
    // MARK: - Declarations
    public static let LHWPushButtonTouchDownDuration: CGFloat = 0.22
    public static let LHWPushButtonTouchDownDelay: CGFloat = 0.0
    public static let LHWPushButtonTouchDownDamping: CGFloat = 0.6
    public static let LHWPushButtonTouchDownVelocity: CGFloat = 0.0
    public static let LHWPushButtonTouchUpDuration: CGFloat = 0.7
    public static let LHWPushButtonTouchUpDelay: CGFloat = 0.0
    public static let LHWPushButtonTouchUpDamping: CGFloat = 0.65
    public static let LHWPushButtonTouchUpVelocity: CGFloat = 0.0
    
    
    // MARK: - Variables
    
    // Original Transform Property
    open var originalTransform = CGAffineTransform.identity {
        didSet  {
            // Update Button Transform
            transform = originalTransform
        }
    }
    
    // Set Highlight Property
    open var highlightStateBackgroundColor: UIColor?
    
    // Push Transform Property
    open var pushTransformScaleFactor: CGFloat = 0.8
    
    // Touch Handler Blocks
    open var touchDownHandler: ((_ button: LHWPushButton) -> Void)?
    open var touchUpHandler: ((_ button: LHWPushButton) -> Void)?
    
    // Push Transition Animation Properties
    open var touchDownDuration: CGFloat = LHWPushButtonTouchDownDuration
    open var touchDownDelay: CGFloat = LHWPushButtonTouchDownDelay
    open var touchDownDamping: CGFloat = LHWPushButtonTouchDownDamping
    open var touchDownVelocity: CGFloat = LHWPushButtonTouchDownVelocity
    
    open var touchUpDuration: CGFloat = LHWPushButtonTouchUpDuration
    open var touchUpDelay: CGFloat = LHWPushButtonTouchUpDelay
    open var touchUpDamping: CGFloat = LHWPushButtonTouchUpDamping
    open var touchUpVelocity: CGFloat = LHWPushButtonTouchUpVelocity
    
    // Add Extra Parameters
    open var extraParameters: Any?
    
    private var normalStateBackgroundColor: UIColor?
    open override var backgroundColor: UIColor? {
        didSet  {
            // Store Normal State Background Color
            normalStateBackgroundColor = backgroundColor
        }
    }
    
    // MARK: - Initialization Methods
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        basicInitialisation()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        basicInitialisation()
    }
    
    open func basicInitialisation() {
        
        // Set Default Original Transform
        originalTransform = CGAffineTransform.identity
    }
    
    
    // MARK: - Touch Events
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        pushButton(pushButton: true, shouldAnimate: true, completion: nil)
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        pushButton(pushButton: false, shouldAnimate: true, completion: nil)
    }
    
    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        pushButton(pushButton: false, shouldAnimate: true, completion: nil)
    }
    
    
    // MARK: - Animation Method
    open func pushButton(pushButton: Bool, shouldAnimate: Bool, completion: (() -> Void)?) {
        
        // Call Touch Events
        if pushButton {
            // Call Touch Down Handler
            if let touchDownHandler = touchDownHandler {
                touchDownHandler(self)
            }
        } else {
            // Call Touch Up Handler
            if let touchUpHandler = touchUpHandler {
                touchUpHandler(self)
            }
        }
        
        // Animation Block
        let animate: ((_: Void) -> Void)? = {() -> Void in
            
            if pushButton {
                // Set Transform
                self.transform = self.originalTransform.scaledBy(x: self.pushTransformScaleFactor, y: self.pushTransformScaleFactor)
                // Update Background Color
                if (self.highlightStateBackgroundColor != nil) {
                    super.backgroundColor = self.highlightStateBackgroundColor
                }
            } else {
                // Set Transform
                self.transform = self.originalTransform
                // Set Background Color
                super.backgroundColor = self.normalStateBackgroundColor
            }
            
            // Layout
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }
        
        if shouldAnimate {
            
            // Configure Animation Properties
            var duration: CGFloat
            var delay: CGFloat
            var damping: CGFloat
            var velocity: CGFloat
            if pushButton {
                duration = touchDownDuration
                delay = touchDownDelay
                damping = touchDownDamping
                velocity = touchDownVelocity
            } else {
                duration = touchUpDuration
                delay = touchUpDelay
                damping = touchUpDamping
                velocity = touchUpVelocity
            }
            
            DispatchQueue.main.async(execute: {() -> Void in
                // Animate
                UIView.animate(withDuration: TimeInterval(duration), delay: TimeInterval(delay), usingSpringWithDamping: damping, initialSpringVelocity: velocity, options: [.curveEaseOut, .beginFromCurrentState, .allowUserInteraction], animations: {() -> Void in
                    animate!()
                }, completion: {(_ finished: Bool) -> Void in
                    if let completion = completion, finished {
                        completion()
                    }
                })
            })
        } else {
            animate!()
            
            // Call Completion Block
            if let completion = completion {
                completion()
            }
        }
    }
}

