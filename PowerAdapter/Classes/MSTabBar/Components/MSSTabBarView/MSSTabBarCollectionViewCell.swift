//  Converted to Swift 5.1 by Swiftify v5.1.31847 - https://swiftify.com/
//
//  MSSTabBarCollectionViewCell.swift
//  TabbedPageViewController
//
//  Created by Merrick Sapsford on 13/01/2016.
//  Copyright © 2016 Merrick Sapsford. All rights reserved.
//

import UIKit

class MSSTabBarCollectionViewCell: UICollectionViewCell {
    
    var textColor: UIColor? {
        didSet {
            if !isSelected {
                textTitleLabel.textColor = textColor
                imageTextTitleLabel.textColor = textColor
            }
        }
    }

    var textFont: UIFont? {
        didSet{
            if !isSelected {
                textTitleLabel.font = textFont
                imageTextTitleLabel.font = textFont
            }
        }
    }

    var tabBackgroundColor: UIColor? {
        didSet {
            if !isSelected {
                backgroundColor = tabBackgroundColor
            }
        }
    }

    var selectedTextColor: UIColor? {
        didSet {
            if isSelected {
                textTitleLabel.textColor = selectedTextColor
                imageTextTitleLabel.textColor = selectedTextColor
            }
        }
    }

    var selectedTextFont: UIFont? {
        didSet {
            if isSelected {
                textTitleLabel.font = selectedTextFont
                imageTextTitleLabel.font = selectedTextFont
            }
        }
    }

    var selectedTabBackgroundColor: UIColor? {
        didSet {
            if isSelected {
                backgroundColor = selectedTabBackgroundColor
            }
        }
    }

    var selectionProgress: CGFloat = 0.0 {
        didSet {
            updateProgressiveAppearance()
            updateSelectionAppearance()
        }
    }

    var alphaEffectEnabled: Bool = true {
        didSet {
            if alphaEffectEnabled {
                updateProgressiveAppearance()
            } else {
                textTitleLabel.alpha = 1.0
                imageTextTitleLabel.alpha = 1.0
            }
        }
    }
    
    

    

    func setContentBottomMargin(_ contentBottomMargin: CGFloat) {
        containerViewBottomMargin.constant = contentBottomMargin
    }

    /// The style of the tab.
    var tabStyle: MSSTabStyle! {
        didSet {
            switch tabStyle {
                case .imageAndText:
                    textContainerView.isHidden = true
                    imageContainerView.isHidden = true
                    imageTextContainerView.isHidden = false
                case .image:
                    textContainerView.isHidden = true
                    imageContainerView.isHidden = false
                    imageTextContainerView.isHidden = true
                default:
                    textContainerView.isHidden = false
                    imageContainerView.isHidden = true
                    imageTextContainerView.isHidden = true
            }
        }
    }
    /// The image displayed in the tab cell.
    /// NOTE - only visible when using MSSTabStyleImage.

    var image: UIImage? {
        get {
            return imageImageView.image
        }
        set(image) {
            if tabStyle == .image || tabStyle == .imageAndText {
                imageImageView.image = image
                imageTextImageView.image = image
            }
        }
    }
    /// The text displayed in the tab cell.
    /// NOTE - only visible when using MSSTabStyleText.

    var title: String? {
        get {
            return textTitleLabel.text
        }
        set(title) {
            textTitleLabel.text = title
            imageTextTitleLabel.text = title
        }
    }
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var textContainerView: UIView!
    @IBOutlet private weak var textTitleLabel: UILabel!
    @IBOutlet private weak var imageContainerView: UIView!
    @IBOutlet private weak var imageImageView: UIImageView!
    @IBOutlet private weak var imageTextContainerView: UIView!
    @IBOutlet private weak var imageTextTitleLabel: UILabel!
    @IBOutlet private weak var imageTextImageView: UIImageView!
    @IBOutlet private weak var containerViewBottomMargin: NSLayoutConstraint!

// MARK: - Init

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        baseInit()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        baseInit()
    }

    func baseInit() {
        
    }

// MARK: - Public

// MARK: - Private

// MARK: - Internal
    func updateProgressiveAppearance() {
        switch tabStyle {
            case .text, .imageAndText:
                if alphaEffectEnabled {
                    textTitleLabel.alpha = selectionProgress
                    imageTextTitleLabel.alpha = selectionProgress
                }
            default:
                break
        }
    }

    func updateSelectionAppearance() {
        let isSelected = selectionProgress == 1.0
        if self.isSelected != isSelected {
            // update selected state

            if selectedTextFont != nil || selectedTextColor != nil {
                UIView.transition(with: self, duration: 0.2, options: .transitionCrossDissolve, animations: {
                    if self.selectedTextColor != nil {
                        let textColor = isSelected ? self.selectedTextColor : self.textColor
                        self.textTitleLabel.textColor = textColor
                        self.imageTextTitleLabel.textColor = textColor
                    } else {
                        self.textTitleLabel.textColor = self.textColor
                        self.imageTextTitleLabel.textColor = self.textColor
                    }

                    if self.selectedTextFont != nil {
                        let textFont = isSelected ? self.selectedTextFont : self.textFont
                        self.textTitleLabel.font = textFont
                        self.imageTextTitleLabel.font = textFont
                    } else {
                        self.textTitleLabel.font = self.textFont
                        self.imageTextTitleLabel.font = self.textFont
                    }

                    if self.selectedTabBackgroundColor != nil {
                        self.backgroundColor = isSelected ? self.selectedTabBackgroundColor : self.tabBackgroundColor
                    } else {
                        self.backgroundColor = self.tabBackgroundColor
                    }

                })
            }

            self.isSelected = isSelected
            self.isSelected = isSelected
        }
    }
}
