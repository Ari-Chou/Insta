//
//  CommentCell.swift
//  Insta
//
//  Created by AriChou on 2/11/21.
//

import UIKit
import SDWebImage

class CommentCell: UICollectionViewCell {
    
    // MARK: - Properties
    var viewModel: CommentViewModel? {
        didSet {
            profileImageView.sd_setImage(with: viewModel?.profileImageUrl, completed: nil)
            commentLabel.attributedText = viewModel?.commentLabelText()
        }
    }
    
    private let profileImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 30
        imageView.backgroundColor = .darkGray
        return imageView
    }()
    
    private let commentLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Configure UI

extension CommentCell {
    
   private func configureUI() {
        addSubview(profileImageView)
        addSubview(commentLabel)
    
    for view in subviews {
        view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    NSLayoutConstraint.activate([
        profileImageView.heightAnchor.constraint(equalToConstant: 60),
        profileImageView.widthAnchor.constraint(equalToConstant: 60),
        profileImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        
        commentLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 15),
        commentLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
        commentLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
    ])
    }
}
