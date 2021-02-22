//
//  NotificationService.swift
//  Insta
//
//  Created by AriChou on 2/22/21.
//

import Foundation
import Firebase


struct NotificationService {
    static func uploadNotification(toUid uid: String, type: NotificationType, post: Post? = nil) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        guard uid != currentUid else { return }
        
        let docRef = COLLECTION_NOTIFICATION.document(uid).collection("user-notification").document()
        
        var data:[String: Any] = ["timestamp": Timestamp(date: Date()), "uid": currentUid, "type": type.rawValue, "id": docRef.documentID]
        
        if let post = post {
            data["postId"] = post.postId
            data["postImageUrl"] = post.imageUrl
        }
        
        docRef.setData(data)
    }
    
    static func fetchNotification() {
        
    }
}
