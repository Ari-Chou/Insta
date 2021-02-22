//
//  AuthService.swift
//  Insta
//
//  Created by AriChou on 2/4/21.
//

import UIKit
import Firebase

struct AuthCredentials {
    let email: String
    let username: String
    let password: String
    let prrofileImage: UIImage
}

struct AuthService {
    
    static func loguserIn(email: String, password: String, completion: AuthDataResultCallback?) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    static func registerUser(withCredentials credentials: AuthCredentials, completion: @escaping(Error?) -> Void) {
        
        ImageUploader.uploadImage(image: credentials.prrofileImage) { (imageUrl) in
            Auth.auth().createUser(withEmail: credentials.email, password: credentials.password) { (authresult, error) in
                if let error = error {
                    print("创建新用户失败", error.localizedDescription)
                    return
                }
                print("创建新用户成功，并存储用户信息")
                guard let uid = authresult?.user.uid else { return }
                let userInfo: [String: Any] = ["email": credentials.email,
                                               "username": credentials.username,
                                               "imageUrl": imageUrl,
                                               "UID": uid]
                
                COLLECTION_USERS.document(uid).setData(userInfo, completion: (completion))
                }
            }
        }
    }

