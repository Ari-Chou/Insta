//
//  TextField + EXT.swift
//  Instagram
//
//  Created by AriChou on 2/1/21.
//

import UIKit

extension UITextField {
    
    /// Text input default style
    convenience init(placeholder: String?, backgroundColor: UIColor? = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1), cornerRadius: CGFloat) {
        self.init()
        self.placeholder = placeholder
        self.backgroundColor = backgroundColor
        layer.cornerRadius = cornerRadius
        borderStyle = .none
        let spaceView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        leftView = spaceView
        leftViewMode = UITextField.ViewMode.always
    }
}

