//
//  NotificationViewModel.swift
//  Insta
//
//  Created by AriChou on 2/22/21.
//

import UIKit

struct NotificationViewModel {
    
    let notification: Notification
    
    var postImageUrl: URL? {
        return URL(string: notification.postImageUrl ?? "")
    }
    
    var profileImageUrl: URL? {
        return URL(string: notification.profileImageUrl)
    }
    
    var notificationMessage: NSAttributedString {
        let username = notification.username
        let message = notification.type.notificationMessage
        
        let attributedText = NSMutableAttributedString(string: username, attributes: [.font: UIFont.systemFont(ofSize: 14, weight: .bold)])
        
        attributedText.append(NSAttributedString(string: message, attributes: [.font: UIFont.systemFont(ofSize: 14)]))
        
        return attributedText
    }
    
    var hidePostImage: Bool {
        return notification.type == .follow
    }
    
    init(notification: Notification) {
        self.notification = notification
    }
    
}
