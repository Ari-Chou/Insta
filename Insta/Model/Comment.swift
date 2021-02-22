//
//  Comment.swift
//  Insta
//
//  Created by AriChou on 2/20/21.
//

import Foundation
import Firebase

struct Comment {
    var commentText: String
    let profileImageUrl: String
    let uid: String
    let timestamp: Timestamp
    let username: String
    
    init(dictionary: [String: Any]) {
        self.commentText = dictionary["comment"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        self.username = dictionary["username"] as? String ?? ""
    }
}
