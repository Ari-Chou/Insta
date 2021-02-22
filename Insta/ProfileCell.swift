//
//  ProfileCell.swift
//  Insta
//
//  Created by AriChou on 2/4/21.
//

import UIKit
import SDWebImage

class ProfileCell: UICollectionViewCell {
    
    // MARK: - Propertise
    var viewModel: PostViewModel? {
        didSet {
            postImageView.sd_setImage(with: viewModel?.imageUrl, completed: nil)
        }
    }
    
   // MARK: - UI Element
    let postImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

// MARK: - Configure UI
extension ProfileCell {
    private func configureUI() {
        addSubview(postImageView)
        for view in subviews {
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            postImageView.topAnchor.constraint(equalTo: self.topAnchor),
            postImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            postImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            postImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
}
