//
//  FeedCollectionViewCell.swift
//  Insta
//
//  Created by AriChou on 2/3/21.
//

import UIKit
import SDWebImage

protocol FeedCellDelegate: class {
    func cell(_ cell: FeedCell, wantsToShowController post: Post)
    func cell(_ cell: FeedCell, didLike post: Post)
    func cell(_ cell: FeedCell, wantsTosShowProfile uid: String)
}

class FeedCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    weak var delagate: FeedCellDelegate?
    
    var viewModel: PostViewModel?{
        didSet {
            captionLabel.text = viewModel?.caption
            postImageView.sd_setImage(with: viewModel?.imageUrl, completed: nil)
            profileImageView.sd_setImage(with: viewModel?.userProfileImageUrl, completed: nil)
            usernameButton.setTitle(viewModel?.usernsme, for: .normal)
            likesLabel.text = viewModel?.postLikeLabel
            likeButton.tintColor = viewModel?.likeButtonColor
            likeButton.setImage(viewModel?.likeButtonImage, for: .normal)
        }
    }
    
     lazy var profileImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.layer.cornerRadius = 20
        imageView.backgroundColor = .red
        return imageView
    }()
    
    lazy var usernameButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Username", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        button.addTarget(self, action: #selector(didTapUsername), for: .touchUpInside)
        return button
    }()
    
    lazy var moreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    lazy var headerStackView = UIStackView(arrangedSubviews: [usernameButton, moreButton])
    
    lazy var postImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .red
        return imageView
    }()
    
    lazy var likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "suit.heart"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(didTapLike), for: .touchUpInside)
        return button
    }()
    
    lazy var commentButton: UIButton = {
       let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "message"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(didTapComment), for: .touchUpInside)
        return button
    }()
    
    lazy var shareButton: UIButton = {
       let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "paperplane"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    lazy var bookmarkButton: UIButton = {
        let button = UIButton()
         button.setImage(UIImage(systemName: "bookmark"), for: .normal)
         button.tintColor = .black
         return button
    }()
    
    lazy var likesLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        label.textAlignment = .left
        return label
    }()
    
    lazy var captionLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.numberOfLines = 2
        label.textAlignment = .left
        return label
    }()
    
    lazy var postTimeLabel: UILabel = {
       let label = UILabel()
        label.text = "22 day ago"
        label.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        label.textAlignment = .left
        label.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        return label
    }()
    
    lazy var footerSubStackView = UIStackView(arrangedSubviews: [likeButton, commentButton, shareButton])
    lazy var footStackView = UIStackView(arrangedSubviews: [footerSubStackView, bookmarkButton])
    lazy var labelStackView = UIStackView(arrangedSubviews: [likesLabel, captionLabel, postTimeLabel])
    
    // MARK: - UI Action
    @objc func didTapUsername() {
        guard let viewModel = viewModel else { return }
        delagate?.cell(self, wantsTosShowProfile: viewModel.post.ownerUid)
    }
    
    @objc func didTapComment() {
        guard let viewModel = viewModel else { return }
        delagate?.cell(self, wantsToShowController: viewModel.post)
    }
    
    @objc func didTapLike() {
        guard let viewModel = viewModel else { return }
        delagate?.cell(self, didLike: viewModel.post)
    }
    
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
extension FeedCell {
    private func configureUI() {
        addSubview(profileImageView)
        addSubview(headerStackView)
        addSubview(postImageView)
        addSubview(footStackView)
        addSubview(labelStackView)
        
        
        headerStackView.axis = .horizontal
        headerStackView.distribution = .equalSpacing
        
        footerSubStackView.axis = .horizontal
        footerSubStackView.spacing = 10
        
        footStackView.axis = .horizontal
        footStackView.distribution = .equalSpacing
        
        labelStackView.axis = .vertical
        labelStackView.spacing = 5
        
//        labelStackView.backgroundColor = .blue
        
        for view in subviews {
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            profileImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            profileImageView.widthAnchor.constraint(equalToConstant: 40),
            profileImageView.heightAnchor.constraint(equalToConstant: 40),
            
            headerStackView.topAnchor.constraint(equalTo: self.topAnchor),
            headerStackView.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 10),
            headerStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            headerStackView.heightAnchor.constraint(equalToConstant: 60),
            
            postImageView.topAnchor.constraint(equalTo: headerStackView.bottomAnchor),
            postImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            postImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            postImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1),
            
            footStackView.topAnchor.constraint(equalTo: postImageView.bottomAnchor, constant: 10),
            footStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            footStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            footStackView.heightAnchor.constraint(equalToConstant: 20),
            
            labelStackView.topAnchor.constraint(equalTo: footStackView.bottomAnchor, constant: 10),
            labelStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            labelStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            
            
        ])
    }
}
