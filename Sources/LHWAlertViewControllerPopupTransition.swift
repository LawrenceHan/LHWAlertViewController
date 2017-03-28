//
//  LHWAlertViewControllerPopupTransition.swift
//  LHWAlertViewControllerDemo
//
//  Created by Shivam Bhalla on 1/20/17.
//  Copyright © 2017 Codigami Inc. All rights reserved.
//
//
//  LHWAlertViewControllerPopupTransition.swift
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

public class LHWAlertViewControllerPopupTransition: NSObject {
    
    // MARK: - Declarations
    public enum LHWAlertPopupTransitionType : Int {
        case present = 0
        case dismiss
    }
    
    
    // MARK: - Variables
    public var transitionType = LHWAlertPopupTransitionType(rawValue: 0)
    
    
    // MARK: - Initialisation Methods
    public override init() {
        super.init()
        
        // Default Transition Type
        transitionType = LHWAlertPopupTransitionType(rawValue: 0)
    }
}


// MARK: - UIViewControllerAnimatedTransitioning
extension LHWAlertViewControllerPopupTransition: UIViewControllerAnimatedTransitioning   {
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        // Get context vars
        let duration: TimeInterval = self.transitionDuration(using: transitionContext)
        let containerView: UIView? = transitionContext.containerView
        let fromViewController: UIViewController? = transitionContext.viewController(forKey: .from)
        let toViewController: UIViewController? = transitionContext.viewController(forKey: .to)
        
        // Call Will System Methods
        fromViewController?.beginAppearanceTransition(false, animated: true)
        toViewController?.beginAppearanceTransition(true, animated: true)
        if self.transitionType == .present {
            
            /** SHOW ANIMATION **/
            if let alertViewController = toViewController as? LHWAlertViewController, let containerView = containerView   {
                
                alertViewController.containerView?.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
                alertViewController.view?.frame = containerView.frame
                alertViewController.view?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                alertViewController.view?.translatesAutoresizingMaskIntoConstraints = true
                containerView.addSubview(alertViewController.view)
                alertViewController.view?.layoutIfNeeded()
                
                // Hide Container View
                alertViewController.containerView?.alpha = 0.0
                
                // Background
                let backgroundColorRef: UIColor? = alertViewController.backgroundColor
                alertViewController.backgroundColor = UIColor.clear
                if alertViewController.backgroundStyle == .blur    {
                    alertViewController.backgroundBlurView?.alpha = 0.0
                }
                
                UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: [.curveEaseIn, .allowUserInteraction, .beginFromCurrentState], animations: {() -> Void in
                    
                    // Background
                    if alertViewController.backgroundStyle == .blur    {
                        alertViewController.backgroundBlurView?.alpha = 1.0
                    }
                    alertViewController.backgroundColor = backgroundColorRef
                    
                }, completion: nil)
                
                // Animate height changes
                UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 14.0, options: [.curveEaseIn, .allowUserInteraction, .beginFromCurrentState], animations: {() -> Void in
                    
                    alertViewController.containerView?.transform = CGAffineTransform.identity
                    alertViewController.containerView?.alpha = 1.0
                    
                }, completion: {(_ finished: Bool) -> Void in
                    
                    // Call Did System Methods
                    toViewController?.endAppearanceTransition()
                    fromViewController?.endAppearanceTransition()
                    
                    // Declare Animation Finished
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                })
            } else {
                
                // Call Did System Methods
                toViewController?.endAppearanceTransition()
                fromViewController?.endAppearanceTransition()
                
                // Declare Animation Finished
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        } else if self.transitionType == .dismiss {
            
            /** HIDE ANIMATION **/
            let alertViewController: LHWAlertViewController? = (fromViewController as? LHWAlertViewController)
            
            // Animate height changes
            UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: [.curveEaseOut, .beginFromCurrentState], animations: {() -> Void in
                
                alertViewController?.containerView?.transform = CGAffineTransform(scaleX: 0.94, y: 0.94)
                alertViewController?.containerView?.alpha = 0.0
                
                // Background
                if alertViewController?.backgroundStyle == .blur    {
                    alertViewController?.backgroundBlurView?.alpha = 0.0
                }
                alertViewController?.view?.backgroundColor = UIColor.clear
                
            }, completion: {(_ finished: Bool) -> Void in
                // Call Did System Methods
                toViewController?.endAppearanceTransition()
                fromViewController?.endAppearanceTransition()
                // Declare Animation Finished
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        }
        
    }
}
