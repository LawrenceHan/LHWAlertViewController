//
//  CFAlertViewController.swift
//  CFAlertViewControllerDemo
//
//  Created by Shardul Patel on 19/01/17.
//  Copyright © 2017 Codigami Inc. All rights reserved.
//
//
//  LHWAlertViewController.swift
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

public class LHWAlertViewController: UIViewController {
    
    // MARK: - Declarations
    
    public typealias LHWAlertViewControllerDismissBlock = (_ isBackgroundTapped: Bool) -> Void
    
    public enum LHWAlertControllerStyle: Int {
        case alert = 0
        case actionSheet
    }
    
    public enum LHWAlertControllerBackgroundStyle: Int {
        case plain = 0
        case blur
    }
    
    public static func LHWAlertBackgroundColor() -> UIColor {
        return UIColor(white: 0.0, alpha: 0.7)
    }
    
    // MARK: - Variables
    
    public internal(set) var textAlignment = NSTextAlignment(rawValue: 0)
    public internal(set) var preferredStyle = LHWAlertControllerStyle(rawValue: 0) {
        didSet  {
            DispatchQueue.main.async(execute: {
                // Position Contraints for Container View
                if self.preferredStyle == .actionSheet {
                    // Set Corner Radius
                    self.containerView?.layer.cornerRadius = 6.0
                    self.containerViewCenterYConstraint?.isActive = false
                    self.containerViewBottomConstraint?.isActive = true
                } else {
                    // Set Corner Radius
                    self.containerView?.layer.cornerRadius = 8.0
                    self.containerViewBottomConstraint?.isActive = false
                    self.containerViewCenterYConstraint?.isActive = true
                }
                self.view.layoutIfNeeded()
            })
        }
    }
    
    public private(set) var actions: [LHWAlertAction]? {
        set {
            // Dont Do Anything
        }
        get {
            return self.actionList
        }
    }
    
    internal var _headerView: UIView?
    public var headerView: UIView? {
        set {
            self.setHeaderView(newValue, shouldUpdateContainerFrame: true, withAnimation: true)
        }
        get {
            return _headerView
        }
    }
    
    internal var _footerView: UIView?
    public var footerView: UIView?  {
        set {
            self.setFooterView(newValue, shouldUpdateContainerFrame: true, withAnimation: true)
        }
        get {
            return _footerView
        }
    }
    
    // Background
    public var backgroundStyle = LHWAlertControllerBackgroundStyle.plain    {
        didSet  {
            if isViewLoaded {
                // Set Background
                if backgroundStyle == .blur {
                    // Set Blur Background
                    backgroundBlurView?.alpha = 1.0
                }
                else {
                    // Display Plain Background
                    backgroundBlurView?.alpha = 0.0
                }
            }
        }
    }
    
    public var backgroundColor: UIColor?    {
        didSet  {
            if isViewLoaded {
                view.backgroundColor = backgroundColor
            }
        }
    }
    @IBOutlet public weak var backgroundBlurView: UIVisualEffectView?
    public var shouldDismissOnBackgroundTap: Bool = true    // Default is True
    
    @IBOutlet public weak var containerView: UIView?        // Reference Container View For Transition
    
    // MARK: Private / Internal
    
    internal var titleString: String?
    internal var messageString: String?
    internal var actionList = [LHWAlertAction]()
    internal var dismissHandler: LHWAlertViewControllerDismissBlock?
    internal var keyboardHeight: CGFloat = 0.0 {
        didSet  {
            // Check if keyboard Height Changed
            if keyboardHeight != oldValue {
                
                // Update Main View Bottom Constraint
                mainViewBottomConstraint?.constant = keyboardHeight
            }
        }
    }
    
    internal var tapGesture: UITapGestureRecognizer!
    
    @IBOutlet internal weak var mainViewBottomConstraint: NSLayoutConstraint?
    @IBOutlet internal weak var tableView: UITableView?
    @IBOutlet internal weak var containerViewCenterYConstraint: NSLayoutConstraint?
    @IBOutlet internal weak var containerViewBottomConstraint: NSLayoutConstraint?
    @IBOutlet internal weak var tableViewHeightConstraint: NSLayoutConstraint?
    
    
    // MARK: - Initialisation Method
    
    public class func alertController(title: String?,
                                      message: String?,
                                      textAlignment: NSTextAlignment,
                                      preferredStyle: LHWAlertControllerStyle,
                                      didDismissAlertHandler dismiss: LHWAlertViewControllerDismissBlock?) -> LHWAlertViewController {
        
        return LHWAlertViewController.alertController(title: title,
                                                     message: message,
                                                     textAlignment: textAlignment,
                                                     preferredStyle: preferredStyle,
                                                     headerView: nil,
                                                     footerView: nil,
                                                     didDismissAlertHandler: dismiss)
    }
    
    public class func alertController(title: String?,
                                      message: String?,
                                      textAlignment: NSTextAlignment,
                                      preferredStyle: LHWAlertControllerStyle,
                                      headerView: UIView?,
                                      footerView: UIView?,
                                      didDismissAlertHandler dismiss: LHWAlertViewControllerDismissBlock?) -> LHWAlertViewController {
        
        // Get Current Bundle
        let bundle = Bundle(for: LHWAlertViewController.self)
        
        // Create New Instance Of Alert Controller
        let alert = LHWAlertViewController.init(nibName: "LHWAlertViewController", bundle: bundle)
        
        // Assign Properties
        alert.preferredStyle = preferredStyle
        alert.backgroundStyle = .plain
        alert.backgroundColor = LHWAlertBackgroundColor()
        alert.titleString = title
        alert.messageString = message
        alert.textAlignment = textAlignment
        alert.setHeaderView(headerView, shouldUpdateContainerFrame: false, withAnimation: false)
        alert.setFooterView(footerView, shouldUpdateContainerFrame: false, withAnimation: false)
        alert.dismissHandler = dismiss
        
        // Custom Presentation
        alert.modalPresentationStyle = .custom
        alert.transitioningDelegate = alert
        
        return alert
    }
    
    
    // MARK: - View Life Cycle Methods
    
    internal func loadVariables() {
        
        // Register For Keyboard Notification Observer
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        // Text Field & Text View Notifications
        NotificationCenter.default.addObserver(self, selector: #selector(textViewOrTextFieldDidBeginEditing), name: NSNotification.Name.UITextFieldTextDidBeginEditing, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(textViewOrTextFieldDidBeginEditing), name: NSNotification.Name.UITextViewTextDidBeginEditing, object: nil)
        
        // Register Cells For Table
        let actionCellNib = UINib(nibName: LHWAlertActionTableViewCell.identifier(), bundle: Bundle(for: LHWAlertActionTableViewCell.self))
        tableView?.register(actionCellNib, forCellReuseIdentifier: LHWAlertActionTableViewCell.identifier())
        let titleSubtitleCellNib = UINib(nibName: LHWAlertTitleSubtitleTableViewCell.identifier(), bundle: Bundle(for: LHWAlertTitleSubtitleTableViewCell.self))
        tableView?.register(titleSubtitleCellNib, forCellReuseIdentifier: LHWAlertTitleSubtitleTableViewCell.identifier())
        
        // Add Key Value Observer
        tableView?.addObserver(self, forKeyPath: "contentSize", options: [.new, .old, .prior], context: nil)
    }
    
    internal func loadDisplayContent() {
        
        // Add Tap Gesture Recognizer On View
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.viewDidTap))
        view.addGestureRecognizer(self.tapGesture)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load Variables
        loadVariables()
        
        // Load Display Content
        loadDisplayContent()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Update UI
        updateUI(withAnimation: false)
    }
    
    
    // MARK: - Helper Methods
    
    public func addAction(_ action: LHWAlertAction?) {
        
        if let action = action {
            
            // Check For Cancel Action. Every Alert must have maximum 1 Cancel Action.
            if action.style == .Cancel {
                for existingAction: LHWAlertAction in actionList {
                    // This line of code added to just supress the warning (Unused Variable) at build time
                    //unused(existingAction)
                    // It means this alert already contains a Cancel action. Throw an Assert so developer understands the reason.
                    assert(existingAction.style != .Cancel, "ERROR : LHWAlertViewController can only have one action with a style of LHWAlertActionStyle.Cancel")
                }
            }
            // Add Action Into List
            actionList.append(action)
        } else {
            print("WARNING >>> LHWAlertViewController received nil action to add. It must not be nil.")
        }
    }
    
    public func dismissAlert(withAnimation animate: Bool, completion: ((_: Void) -> Void)?) {
        dismissAlert(withAnimation: animate, isBackgroundTapped: false, completion: completion)
    }
    
    internal func dismissAlert(withAnimation animate: Bool, isBackgroundTapped: Bool, completion: ((_: Void) -> Void)?) {
        
        // Dismiss Self
        self.dismiss(animated: animate, completion: {() -> Void in
            // Call Completion Block
            if let completion = completion {
                completion()
            }
            // Call Dismiss Block
            if let dismissHandler = self.dismissHandler {
                dismissHandler(isBackgroundTapped)
            }
        })
    }
    
    internal func setHeaderView(_ headerView: UIView?, shouldUpdateContainerFrame: Bool, withAnimation animate: Bool) {
        _headerView = headerView
        // Set Into Table Header View
        if let tableView = tableView    {
            tableView.tableHeaderView = self.headerView
            // Update Container View Frame If Requested
            if shouldUpdateContainerFrame {
                updateContainerViewFrame(withAnimation: animate)
            }
        }
    }
    
    internal func setFooterView(_ footerView: UIView?, shouldUpdateContainerFrame: Bool, withAnimation animate: Bool) {
        _footerView = footerView
        // Set Into Table Footer View
        if let tableView = tableView    {
            tableView.tableFooterView = self.footerView
            // Update Container View Frame If Requested
            if shouldUpdateContainerFrame {
                updateContainerViewFrame(withAnimation: animate)
            }
        }
    }
    
    internal func updateUI(withAnimation shouldAnimate: Bool) {
        // Refresh Preferred Style
        preferredStyle = (preferredStyle)
        // Update Table Header View
        setHeaderView(headerView, shouldUpdateContainerFrame: false, withAnimation: false)
        // Update Table Footer View
        setFooterView(footerView, shouldUpdateContainerFrame: false, withAnimation: false)
        // Reload Table Content
        tableView?.reloadData()
        // Update Background
        backgroundStyle = (backgroundStyle)
        // Update Container View Frame
        updateContainerViewFrame(withAnimation: shouldAnimate)
    }
    
    internal func updateContainerViewFrame(withAnimation shouldAnimate: Bool) {
        
        let animate: ((_: Void) -> Void)? = {() -> Void in
            
            if let tableView = self.tableView   {
                
                // Update Content Size
                self.tableViewHeightConstraint?.constant = tableView.contentSize.height
                
                // Enable / Disable Bounce Effect
                if let containerView = self.containerView, tableView.contentSize.height <= containerView.frame.size.height {
                    tableView.bounces = false
                } else {
                    tableView.bounces = true
                }
            }
        }
        
        DispatchQueue.main.async(execute: {() -> Void in
            if shouldAnimate {
                // Animate height changes
                UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: [.curveEaseOut, .beginFromCurrentState, .allowUserInteraction], animations: {() -> Void in
                    // Animate
                    animate!()
                    // Relayout
                    self.view.layoutIfNeeded()
                }, completion: { _ in })
            } else {
                animate!()
            }
        })
    }
    
    
    // MARK: - Handle Tap Events
    
    internal func viewDidTap(_ gestureRecognizer: UITapGestureRecognizer) {
        
        // Get Tap Location
        let tapLocation: CGPoint = gestureRecognizer.location(in: self.view)
        
        if let containerView = self.containerView, containerView.frame.contains(tapLocation) {
            // Close Keyboard
            self.view.endEditing(true)
        } else if shouldDismissOnBackgroundTap {
            // Dismiss Alert
            dismissAlert(withAnimation: true, isBackgroundTapped: true, completion: {() -> Void in
                // Simulate Cancel Button
                for existingAction: LHWAlertAction in self.actionList {
                    if existingAction.style == .Cancel {
                        // Call Action Handler
                        if let actionHandler = existingAction.handler {
                            actionHandler(existingAction)
                        }
                    }
                }
            })
        }
    }
    
    
    // MARK: - UIKeyboardWillShowNotification
    
    internal func keyboardWillShow(_ notification: Notification) {
        
        let info: [AnyHashable: Any]? = notification.userInfo
        if let info = info  {
            if let kbRect = info[UIKeyboardFrameEndUserInfoKey] as? CGRect {
                if let viewRect = self.view.window?.convert(self.view.frame, from: self.view)   {
                    let intersectRect: CGRect = kbRect.intersection(viewRect)
                    if intersectRect.size.height > 0.0 {
                        
                        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: [.beginFromCurrentState, .curveEaseOut, .allowUserInteraction], animations: {() -> Void in
                            // Update Keyboard Height
                            self.keyboardHeight = intersectRect.size.height
                            self.view.layoutIfNeeded()
                        }, completion: { _ in })
                    }
                }
            }
        }
    }
    
    // MARK: UIKeyboardWillHideNotification
    
    internal func keyboardWillHide(_ notification: Notification) {
        
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: [.beginFromCurrentState, .curveEaseOut, .allowUserInteraction], animations: {() -> Void in
            // Update Keyboard Height
            self.keyboardHeight = 0.0
            self.view.layoutIfNeeded()
        }, completion: { _ in })
    }
    
    // MARK: UITextViewTextDidBeginEditingNotification | UITextFieldTextDidBeginEditingNotification
    
    internal func textViewOrTextFieldDidBeginEditing(_ notification: Notification) {
        
        if let notificationObject = notification.object, (notificationObject is UITextField || notificationObject is UITextView) {
            
            DispatchQueue.main.async(execute: {() -> Void in
                let view: UIView? = (notificationObject as? UIView)
                if let view = view  {
                    
                    // Keyboard becomes visible
                    UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: [.beginFromCurrentState, .curveEaseOut, .allowUserInteraction], animations: {() -> Void in
                        // Get Location Of View inside Table View
                        let visibleRect: CGRect? = self.tableView?.convert(view.frame, from: view.superview)
                        // Scroll To Visible Rect
                        self.tableView?.scrollRectToVisible(visibleRect!, animated: false)
                    }, completion: { _ in })
                }
            })
        }
    }
    
    
    // MARK: - View Rotation / Size Change Method
    
    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        // Code here will execute before the rotation begins.
        // Equivalent to placing it in the deprecated method -[willRotateToInterfaceOrientation:duration:]
        coordinator.animate(alongsideTransition: {(_ context: UIViewControllerTransitionCoordinatorContext) -> Void in
            // Place code here to perform animations during the rotation.
            // You can pass nil or leave this block empty if not necessary.
            // Update UI
            self.updateUI(withAnimation: false)
        }, completion: {(_ context: UIViewControllerTransitionCoordinatorContext) -> Void in
            // Code here will execute after the rotation has finished.
            // Equivalent to placing it in the deprecated method -[didRotateFromInterfaceOrientation:]
        })
    }
    
    
    // MARK: - Key Value Observers
    
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (keyPath == "contentSize") {
            // Update Container View Frame Without Animation
            updateContainerViewFrame(withAnimation: false)
        }
    }
    
    
    // MARK: - StatusBar Update Methods
    
    #if NS_EXTENSION_UNAVAILABLE_IOS
    override func prefersStatusBarHidden() -> Bool {
        return UIApplication.shared.statusBarHidden
    }
    #endif
    
    
    // MARK: - Dealloc
    
    deinit {
        // Remove KVO
        tableView?.removeObserver(self, forKeyPath: "contentSize")
        print("Popup Dealloc")
    }
}


extension LHWAlertViewController: UITableViewDataSource, UITableViewDelegate, LHWAlertActionTableViewCellDelegate {
    
    // MARK: - UITableViewDataSource
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
            
        case 0:
            if let titleString = self.titleString, !titleString.isEmpty {
                return 1
            }
            if let messageString = self.messageString, !messageString.isEmpty {
                return 1
            }
            
        case 1:
            return self.actionList.count
            
        default:
            break
        }
        
        return 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell?
        
        switch indexPath.section {
            
        case 0:
            // Get Title Subtitle Cell Instance
            cell = tableView.dequeueReusableCell(withIdentifier: LHWAlertTitleSubtitleTableViewCell.identifier())
            let titleSubtitleCell: LHWAlertTitleSubtitleTableViewCell? = (cell as? LHWAlertTitleSubtitleTableViewCell)
            // Set Content
            titleSubtitleCell?.setTitle(titleString, subtitle: messageString, alignment: textAlignment!)
            // Set Content Margin
            titleSubtitleCell?.contentTopMargin = 20.0
            if self.actionList.count <= 0 {
                titleSubtitleCell?.contentBottomMargin = 20.0
            } else {
                titleSubtitleCell?.contentBottomMargin = 0.0
            }
            
        case 1:
            // Get Action Cell Instance
            cell = tableView.dequeueReusableCell(withIdentifier: LHWAlertActionTableViewCell.identifier())
            let actionCell: LHWAlertActionTableViewCell? = (cell as? LHWAlertActionTableViewCell)
            // Set Delegate
            actionCell?.delegate = self
            // Set Action
            actionCell?.action = self.actionList[indexPath.row]
            // Set Top Margin For First Action
            if indexPath.row == 0 {
                if let titleString = titleString, let messageString = messageString, (!titleString.isEmpty && !messageString.isEmpty)   {
                    actionCell?.actionButtonTopMargin = 20.0
                } else {
                    actionCell?.actionButtonTopMargin = 20.0
                }
            }
            
            // Set Bottom Margin For Last Action
            if indexPath.row == self.actionList.count - 1 {
                actionCell?.actionButtonBottomMargin = 20.0
            } else {
                actionCell?.actionButtonBottomMargin = 10.0
            }
            
        default:
            break
        }
        
        return cell!
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    // MARK: UITableViewDelegate
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Deselect Table Cell
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: LHWAlertActionTableViewCellDelegate
    
    public func alertActionCell(_ cell: LHWAlertActionTableViewCell, didClickAction action: LHWAlertAction?) {
        // Dimiss Self
        dismissAlert(withAnimation: true, completion: {() -> Void in
            // Call Action Handler If Set
            if let action = action, let actionHandler = action.handler {
                actionHandler(action)
            }
        })
    }
}


extension LHWAlertViewController: UIViewControllerTransitioningDelegate {
    
    // MARK: - Transitioning Delegate
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if (presented is LHWAlertViewController) {
            if preferredStyle == .alert {
                let transition = LHWAlertViewControllerPopupTransition()
                transition.transitionType = .present
                return transition
            } else {
                let transition = LHWAlertViewControllerActionSheetTransition()
                transition.transitionType = .present
                return transition
            }
        }
        
        return nil
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if (dismissed is LHWAlertViewController) {
            if self.preferredStyle == .alert {
                let transition = LHWAlertViewControllerPopupTransition()
                transition.transitionType = .dismiss
                return transition
            } else {
                let transition = LHWAlertViewControllerActionSheetTransition()
                transition.transitionType = .dismiss
                return transition
            }
        }
        
        return nil
    }
}


