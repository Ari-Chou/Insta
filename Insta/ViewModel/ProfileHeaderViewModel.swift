//
//  ProfileHeaderViewModel.swift
//  Insta
//
//  Created by AriChou on 2/4/21.
//

import UIKit

struct ProfileHeaderViewModel {
    let user: User
    
    var username: String {
        return user.username
    }
    
    var imageUrl: URL? {
        return URL(string: user.profileImageUrl)
    }
    
    var followButtonText: String {
        
        if user.isCurrentUser {
            return "Edit Profile"
        }
        
        return user.isFollowed ? "Following" : "Follow"
    }
    
    var followButtonColor: UIColor {
        return user.isFollowed ? .white : .systemBlue
    }
    
    var followButtonTitleColor: UIColor {
        return user.isFollowed ? .black : .white
    }
    
    var numberOfFollowers: NSAttributedString {
        return setAttributedString(value: user.stats.followers, label: "Follower")
    }
    
    var numberOfFollowing: NSAttributedString {
        return setAttributedString(value: user.stats.following, label: "Following")
    }
    
    var numberOfPost: NSAttributedString {
        return setAttributedString(value: user.stats.posts, label: "Posts")
    }
    
    init(user: User) {
        self.user = user
    }
    
    func setAttributedString(value: Int, label: String) -> NSAttributedString {
        let attributeText = NSMutableAttributedString(string: "\(value)\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        attributeText.append(NSAttributedString(string: label, attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
        return attributeText
    }
}
