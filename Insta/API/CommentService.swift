//
//  CommentService.swift
//  Insta
//
//  Created by AriChou on 2/20/21.
//

import Foundation
import Firebase

struct CommentService {
    
    /// Upload Comment
    static func uploadComment(comment: String, postID: String, user: User, completion: @escaping(FirebaseCompletion)) {
        let data: [String: Any] = ["comment": comment,
                                   "uid": user.uid,
                                   "timestamp": Timestamp(date: Date()),
                                   "username": user.username,
                                   "profileImageUrl": user.profileImageUrl]
        
        COLLECTION_POSTS.document(postID).collection("comments").addDocument(data: data, completion: completion)
    }
    
    /// Fetch Comments
    static func fetchComment(forPost postID: String, completion: @escaping([Comment]) -> Void) {
        var comments = [Comment]()
        
        let query = COLLECTION_POSTS.document(postID).collection("comments").order(by: "timestamp", descending: true)
        
        query.addSnapshotListener { (snapshot, error) in
            snapshot?.documentChanges.forEach({ (change) in
                if change.type == .added {
                    let data = change.document.data()
                    let comment = Comment(dictionary: data)
                    comments.append(comment)
                }
            })
            completion(comments)
        }
    }
}
