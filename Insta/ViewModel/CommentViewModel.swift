//
//  CommentViewModel.swift
//  Insta
//
//  Created by AriChou on 2/20/21.
//

import UIKit

struct CommentViewModel {
    private let comment: Comment
    
    var profileImageUrl: URL? {
        return URL(string: comment.profileImageUrl)
    }
    
    var username: String {
        return comment.username
    }
    
    var commentText: String {
        return comment.commentText
    }
    
    init(comment: Comment) {
        self.comment = comment
    }
    
    func commentLabelText() -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: comment.username, attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedString.append(NSAttributedString(string: "\n\(comment.commentText)", attributes: [.font: UIFont.systemFont(ofSize: 14, weight: .light)]))
        
        return attributedString
    }
}
