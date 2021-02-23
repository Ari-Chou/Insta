//
//  NotificationService.swift
//  Insta
//
//  Created by AriChou on 2/22/21.
//

import Foundation
import Firebase


struct NotificationService {
    
    /// Upload Notification Info From User Who Like/Comment/Follow The Post
    static func uploadNotification(toUid uid: String, fromUser: User, type: NotificationType, post: Post? = nil) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        guard uid != currentUid else { return }
        
        let docRef = COLLECTION_NOTIFICATION.document(uid).collection("user-notification").document()
        
        var data:[String: Any] = ["timestamp": Timestamp(date: Date()),
                                  "fromUserUid": fromUser.uid,
                                  "type": type.rawValue,
                                  "id": docRef.documentID,
                                  "userProfileImageUrl": fromUser.profileImageUrl,
                                  "username":fromUser.username]
        
        if let post = post {
            data["postId"] = post.postId
            data["postImageUrl"] = post.imageUrl
        }
        
        docRef.setData(data)
    }
    
    static func fetchNotification(completion: @escaping([Notification]) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_NOTIFICATION.document(uid).collection("user-notification").getDocuments { (snapshot, _) in
            guard let documents = snapshot?.documents else { return }
            
            let notifications = documents.map({Notification(dictionary: $0.data())})
            completion(notifications)
        }
    }
}
