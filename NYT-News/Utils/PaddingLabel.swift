//
//  PaddingLabel.swift
//  NYT-News
//
//  Created by Beyza Nur Tekerek on 11.04.2025.
//

import Foundation
import UIKit

class PaddingLabel: UILabel {
    var topInset: CGFloat = 4
    var bottomInset: CGFloat = 4
    var leftInset: CGFloat = 8
    var rightInset: CGFloat = 8

    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }
}
