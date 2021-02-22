//
//  UserCellViewModel.swift
//  Insta
//
//  Created by AriChou on 2/6/21.
//

import Foundation

struct UserCellViewModel {
    let user: User
    
    var username: String {
        return user.username
    }
    
    var profileImageUrl: URL? {
        return URL(string: user.profileImageUrl)
    }
    
    init(user: User) {
        self.user = user
    }
}
