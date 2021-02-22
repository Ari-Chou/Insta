//
//  Commons.swift
//  Instagram
//
//  Created by AriChou on 2/1/21.
//

import UIKit
import Firebase

// MARK: - Color
/// Default Color
let darkBlue = UIColor(red: 0.216, green: 0.592, blue: 0.937, alpha: 0.7)
let lightBlue = UIColor(red: 0.216, green: 0.592, blue: 0.937, alpha: 1)

// MARK: - Firebase
let COLLECTION_USERS = Firestore.firestore().collection("users")
let COLLECTION_FOLLOWER = Firestore.firestore().collection("followers")
let COLLECTION_FOLLOWING = Firestore.firestore().collection("following")
let COLLECTION_POSTS = Firestore.firestore().collection("posts")
let COLLECTION_NOTIFICATION = Firestore.firestore().collection("notification")
