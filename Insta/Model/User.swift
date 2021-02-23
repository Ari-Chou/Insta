//
//  User.swift
//  Insta
//
//  Created by AriChou on 2/4/21.
//

import Foundation
import Firebase

struct UserStats {
    let followers: Int
    let following: Int
    var posts: Int
}

struct User {
    let email: String
    let username: String
    let profileImageUrl: String
    let uid: String
    var isFollowed = false
    var stats: UserStats
    
    
    var isCurrentUser: Bool {
        return Auth.auth().currentUser?.uid == uid
    }
    
    init(dictionary: [String: Any]) {
        self.email = dictionary["email"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageUrl = dictionary["imageUrl"] as? String ?? ""
        self.uid = dictionary["UID"] as? String ?? ""
        self.stats = UserStats(followers: 0, following: 0, posts: 0)
    }
}

