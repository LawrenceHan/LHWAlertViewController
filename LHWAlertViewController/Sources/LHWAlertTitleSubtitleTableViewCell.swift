//
//  CFAlertTitleSubtitleTableViewCell.swift
//  CFAlertViewControllerDemo
//
//  Created by Shivam Bhalla on 1/19/17.
//  Copyright © 2017 Codigami Inc. All rights reserved.
//
//
//  LHWAlertTitleSubtitleTableViewCell.swift
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

public class LHWAlertTitleSubtitleTableViewCell: UITableViewCell {
    
    // MARK: - Variables
    
    public static func identifier() -> String {
        return String(describing: LHWAlertTitleSubtitleTableViewCell.self)
    }
    
    @IBOutlet public var titleLabel: UILabel?
    @IBOutlet public var subtitleLabel: UILabel?
    public var contentTopMargin: CGFloat = 0.0 {
        didSet {
            // Update Constraint
            titleLabelTopConstraint?.constant = contentTopMargin - 8.0
            subtitleLabelTopConstraint?.constant = (titleLabelTopConstraint?.constant)!
            layoutIfNeeded()
        }
    }
    
    public var contentBottomMargin: CGFloat = 0.0 {
        didSet {
            // Update Constraint
            titleLabelBottomConstraint?.constant = contentBottomMargin - 8.0
            subtitleLabelBottomConstraint?.constant = (titleLabelBottomConstraint?.constant)!
            layoutIfNeeded()
        }
    }
    
    public var contentLeadingSpace: CGFloat = 0.0 {
        didSet {
            // Update Constraint Values
            titleLeadingSpaceConstraint?.constant = contentLeadingSpace - 8.0
            subtitleLeadingSpaceConstraint?.constant = (titleLeadingSpaceConstraint?.constant)!
            layoutIfNeeded()
        }
    }
    
    // MARK: Private
    
    @IBOutlet private weak var titleLabelTopConstraint: NSLayoutConstraint?
    @IBOutlet private weak var titleLeadingSpaceConstraint: NSLayoutConstraint?
    @IBOutlet private weak var titleLabelBottomConstraint: NSLayoutConstraint?
    @IBOutlet private weak var titleSubtitleVerticalSpacingConstraint: NSLayoutConstraint?
    @IBOutlet private weak var subtitleLabelTopConstraint: NSLayoutConstraint?
    @IBOutlet private weak var subtitleLeadingSpaceConstraint: NSLayoutConstraint?
    @IBOutlet private weak var subtitleLabelBottomConstraint: NSLayoutConstraint?
    
    
    // MARK: Initialization Methods
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        basicInitialisation()
    }
    
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // Initialization code
        basicInitialisation()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    internal func basicInitialisation() {
        // Reset Text
        setTitle(nil, subtitle: nil, alignment: .center)
        // Set Content Leading Space
        contentLeadingSpace = 20.0;
    }
    
    
    // MARK: - Layout Methods
    
    override public func layoutSubviews() {
        contentView.setNeedsLayout()
        contentView.layoutIfNeeded()
    }
    
    // MARK: Helper Methods
    
    public func setTitle(_ title: String?, subtitle: String?, alignment: NSTextAlignment) {
        
        // Set Cell Text Fonts & Colors
        titleLabel?.text = title
        titleLabel?.textAlignment = alignment
        subtitleLabel?.text = subtitle
        subtitleLabel?.textAlignment = alignment
        
        // Update Constraints
        if let titleChars = titleLabel?.text?.characters, let subtitleChars = subtitleLabel?.text?.characters {
            if (titleChars.count <= 0 && subtitleChars.count <= 0) || subtitleChars.count <= 0 {
                titleLabelBottomConstraint?.isActive = true
                subtitleLabelTopConstraint?.isActive = false
                titleSubtitleVerticalSpacingConstraint?.constant = 0.0
            } else if titleChars.count <= 0 {
                titleLabelBottomConstraint?.isActive = false
                subtitleLabelTopConstraint?.isActive = true
                titleSubtitleVerticalSpacingConstraint?.constant = 0.0
            } else {
                titleLabelBottomConstraint?.isActive = false
                subtitleLabelTopConstraint?.isActive = false
                titleSubtitleVerticalSpacingConstraint?.constant = 5.0
            }
        }
    }
}

