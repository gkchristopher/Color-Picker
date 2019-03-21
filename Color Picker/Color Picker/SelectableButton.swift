//Copyright © 2019 Roving Mobile, LLC. All rights reserved.

import UIKit

@IBDesignable
class SelectableButton: RoundedButton {

    @IBInspectable
    override var isSelected: Bool {
        didSet {
            switch isSelected {
            case true:
                layer.borderWidth = borderWidth
            case false:
                layer.borderWidth = 0
            }
        }
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: 34.0, height: 34.0)
    }
}
