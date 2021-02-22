//
//  CommentInputView.swift
//  Insta
//
//  Created by AriChou on 2/18/21.
//

import UIKit

protocol CommentInputAccesoryViewDelegate: class {
    func inputView(_ iputView: CommentInputAccesoryView, wantsToUploadComment comment: String)
}

class CommentInputAccesoryView: UIView {
    
    // MARK: Properties
    
    weak var delegate: CommentInputAccesoryViewDelegate?
    
    private let commentTextView: InputTextView = {
       let textView = InputTextView()
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.isScrollEnabled = false
        textView.placeholderLabel.text = "Enter Comment.."
        return textView
    }()

    private let postButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Post", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handlePostTapped), for: .touchUpInside)
        return button
    }()
    
/// Cleear the text view content
    func clearCommentTextView() {
        commentTextView.text = nil
        commentTextView.placeholderLabel.isHidden = false
    }
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        backgroundColor = .white
        autoresizingMask = .flexibleHeight
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return .zero
    }
}

// MARK: - UI Action
extension CommentInputAccesoryView {
    @objc func handlePostTapped() {
        self.delegate?.inputView(self, wantsToUploadComment: commentTextView.text)
    }
}


// MARK: - Configure UI
extension CommentInputAccesoryView {
    private func configureUI() {
        addSubview(commentTextView)
        addSubview(postButton)
        
        for view in subviews {
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            postButton.topAnchor.constraint(equalTo: self.topAnchor),
            postButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            postButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            postButton.heightAnchor.constraint(equalToConstant: 50),
            
            commentTextView.topAnchor.constraint(equalTo: self.topAnchor),
            commentTextView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            commentTextView.trailingAnchor.constraint(equalTo: postButton.leadingAnchor),
            commentTextView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            
        ])
    }
}
