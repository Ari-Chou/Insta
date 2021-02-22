//
//  InputTextView.swift
//  Insta
//
//  Created by AriChou on 2/8/21.
//

import UIKit

class InputTextView: UITextView {
    
    // MARK: - Properties
    
    var placeholderText: String? {
        didSet {
            placeholderLabel.text = placeholderText
        }
    }
    
     let placeholderLabel: UILabel = {
       let label = UILabel()
        label.textColor = .lightGray
        return label
    }()
    
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        addSubview(placeholderLabel)
        topPlaceholderLabel()
        
        NotificationCenter.default.addObserver(self, selector: #selector(textViewDidChanged), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func textViewDidChanged() {
        placeholderLabel.isHidden = !text.isEmpty
    }
}
// MARK: - Configure UI
extension InputTextView {
    
    private func topPlaceholderLabel() {
        for view in subviews {
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            placeholderLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 4),
            placeholderLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 4),
        ])
    }
    
    private func centerPlaceholderLabel() {
        for view in subviews {
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            placeholderLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}
