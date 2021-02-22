//
//  ProfileHeaderCollectionReusableView.swift
//  Instagram
//
//  Created by AriChou on 2/2/21.
//

import UIKit
import Firebase
import SDWebImage

protocol ProfileHeaderDelegate: class {
    func header(_ profileHeader: ProfileHeader, didTapActionButtonFor user: User)
}

class ProfileHeader: UICollectionReusableView {
    
    // MARK: - Properties
   weak var delegate: ProfileHeaderDelegate?
    
    // MARK: Configure UI Info
    var viewModel: ProfileHeaderViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            print("用户点击了header button")
            usernamelabel.text = viewModel.username
            profileImageView.sd_setImage(with: viewModel.imageUrl, completed: nil)
            editedProfileButton.setTitle(viewModel.followButtonText, for: .normal)
            editedProfileButton.backgroundColor = viewModel.followButtonColor
            editedProfileButton.setTitleColor(viewModel.followButtonTitleColor, for: .normal)
            
            postlabel.attributedText = viewModel.numberOfPost
            followerLabel.attributedText = viewModel.numberOfFollowers
            followingLabel.attributedText = viewModel.numberOfFollowing
        }
    }
    
    // MARK: - UI Element
    lazy var profileImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.circle")
        imageView.tintColor = .lightGray
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 40
        return imageView
    }()
    
    let usernamelabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.text = "Ari-Chpu"
        return label
    }()
    
    lazy var lineView: UIView = {
       let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    lazy var bottomLine: UIView = {
       let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    lazy var postlabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textAlignment = .center
        return label
    }()
    
    lazy var followerLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textAlignment = .center
        return label
    }()
    
    lazy var followingLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textAlignment = .center
        return label
    }()
    
    lazy var editedProfileButton: UIButton = {
       let button = UIButton()
        button.setTitle("Edit Profile", for: .normal)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(handleEditProfileTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var gridButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(systemName: "square.grid.4x3.fill"), for: .normal)
        return button
    }()
    
    lazy var listButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(systemName: "list.bullet"), for: .normal)
        return button
    }()
    
    lazy var bookmarkButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(systemName: "bookmark"), for: .normal)
        return button
    }()
    
    
    lazy var buttonStackView = UIStackView(arrangedSubviews: [gridButton, listButton, bookmarkButton])
    lazy var statuLabelStackView = UIStackView(arrangedSubviews: [postlabel, followerLabel, followingLabel])
    
    // MARK: - UI Action
    @objc func handleEditProfileTapped() {
        guard let viewModel = viewModel else { return }
        delegate?.header(self, didTapActionButtonFor: viewModel.user)
    }
    
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Configure UI
extension ProfileHeader {
    private func setupUI() {
        addSubview(profileImageView)
        addSubview(usernamelabel)
        addSubview(lineView)
        addSubview(statuLabelStackView)
        addSubview(editedProfileButton)
        addSubview(buttonStackView)
        addSubview(bottomLine)
        
        statuLabelStackView.axis = .horizontal
        statuLabelStackView.distribution = .fillEqually
        
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .fillEqually
        buttonStackView.tintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        
        for view in subviews {
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            profileImageView.heightAnchor.constraint(equalToConstant: 80),
            profileImageView.widthAnchor.constraint(equalToConstant: 80),
            
            statuLabelStackView.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 10),
            statuLabelStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            statuLabelStackView.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            
            editedProfileButton.topAnchor.constraint(equalTo: statuLabelStackView.bottomAnchor, constant: 20),
            editedProfileButton.leadingAnchor.constraint(equalTo: statuLabelStackView.leadingAnchor, constant: 20),
            editedProfileButton.trailingAnchor.constraint(equalTo: statuLabelStackView.trailingAnchor, constant: -20),
            editedProfileButton.heightAnchor.constraint(equalToConstant: 30),

            usernamelabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 20),
            usernamelabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor),
            
            buttonStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            buttonStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            buttonStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            buttonStackView.heightAnchor.constraint(equalToConstant: 40),
            
            lineView.bottomAnchor.constraint(equalTo: buttonStackView.topAnchor, constant: 0),
            lineView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            lineView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            lineView.heightAnchor.constraint(equalToConstant: 1),
            
            bottomLine.topAnchor.constraint(equalTo: buttonStackView.bottomAnchor, constant: 0),
            bottomLine.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            bottomLine.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            bottomLine.heightAnchor.constraint(equalToConstant: 1),
            
        ])
    }
}


